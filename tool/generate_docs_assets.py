#!/usr/bin/env python3
"""Generate docs screenshots and demo GIF for segmented_progress_indicator."""

from __future__ import annotations

import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "doc"
SHOTS = OUT / "screenshots"
W, H = 780, 520
BG = (242, 244, 248, 255)
SURFACE = (255, 255, 255, 255)
PRIMARY = (27, 77, 255)
TERTIARY = (90, 70, 200)
TEXT = (28, 32, 40)
MUTED = (100, 110, 125)
CARD = (232, 236, 245, 255)


def font(size: int, bold: bool = False) -> ImageFont.ImageFont:
    candidates = [
        (
            "/System/Library/Fonts/Supplemental/Arial Bold.ttf"
            if bold
            else "/System/Library/Fonts/Supplemental/Arial.ttf"
        ),
        "/System/Library/Fonts/Helvetica.ttc",
        "/Library/Fonts/Arial.ttf",
    ]
    for path in candidates:
        try:
            return ImageFont.truetype(path, size)
        except OSError:
            continue
    return ImageFont.load_default()


def draw_segmented_arc(
    draw: ImageDraw.ImageDraw,
    cx: float,
    cy: float,
    radius: float,
    stroke: float,
    segment_count: int,
    trail: float,
    progress: float,
    color: tuple[int, int, int],
    show_head_dot: bool = True,
) -> None:
    head = progress * segment_count
    segment_angle = 2 * math.pi / segment_count
    arc_length = segment_angle * 0.6

    for i in range(segment_count):
        distance = (head - i + segment_count) % segment_count
        if 0 <= distance <= trail:
            fade = max(0.0, min(1.0, 1.0 - (distance / trail)))
            opacity = fade**1.5
            alpha = int(255 * opacity)
            start = i * segment_angle - math.pi / 2
            end = start + arc_length
            bbox = (cx - radius, cy - radius, cx + radius, cy + radius)
            draw.arc(
                bbox,
                start=math.degrees(start),
                end=math.degrees(end),
                fill=(*color, alpha),
                width=max(1, int(stroke)),
            )

    if show_head_dot:
        head_angle = (head * segment_angle) - math.pi / 2 + arc_length
        dx = cx + radius * math.cos(head_angle)
        dy = cy + radius * math.sin(head_angle)
        r = stroke * 1.15
        draw.ellipse((dx - r, dy - r, dx + r, dy + r), fill=(*color, 255))


def draw_card(
    base: Image.Image,
    x0: int,
    y0: int,
    x1: int,
    y1: int,
    title: str,
    subtitle: str,
) -> ImageDraw.ImageDraw:
    draw = ImageDraw.Draw(base, "RGBA")
    draw.rounded_rectangle((x0, y0, x1, y1), radius=24, fill=SURFACE)
    draw.rounded_rectangle((x0, y0, x1, y1), radius=24, outline=CARD, width=2)
    draw.text((x0 + 24, y0 + 20), title, font=font(22, bold=True), fill=TEXT)
    draw.text((x0 + 24, y0 + 52), subtitle, font=font(15), fill=MUTED)
    return draw


def make_spinner_frame(progress: float) -> Image.Image:
    img = Image.new("RGBA", (W, H), BG)
    draw = draw_card(
        img,
        90,
        70,
        W - 90,
        H - 70,
        "FadingSegmentedSpinner",
        "visibleTrail · showHeadDot · child overlay",
    )

    centers = ((220, 290), (390, 290), (560, 290))
    for idx, (cx, cy) in enumerate(centers):
        color = PRIMARY if idx < 2 else TERTIARY
        draw_segmented_arc(
            draw,
            cx,
            cy,
            radius=42,
            stroke=5,
            segment_count=20,
            trail=6 if idx != 2 else 4,
            progress=progress,
            color=color,
            show_head_dot=idx != 2,
        )
        if idx == 1:
            draw.text(
                (cx - 10, cy - 12),
                "⏳",
                font=font(22),
                fill=PRIMARY,
            )
        if idx == 2:
            draw.text(
                (cx - 14, cy - 12),
                "Go",
                font=font(18, bold=True),
                fill=TERTIARY,
            )

    ImageDraw.Draw(img).text(
        (28, H - 42),
        "Fading segmented spinner",
        font=font(18),
        fill=MUTED,
    )
    return img


def make_value_frame(progress: float) -> Image.Image:
    img = Image.new("RGBA", (W, H), BG)
    draw = draw_card(
        img,
        90,
        70,
        W - 90,
        H - 70,
        "SegmentedProgressIndicator",
        "compact trail · optional centerValue",
    )

    specs = (
        (250, 300, 22, 3.0, 6, None, PRIMARY),
        (390, 300, 28, 3.5, 6, "3", PRIMARY),
        (530, 300, 24, 3.0, 8, "12", TERTIARY),
    )
    for cx, cy, radius, stroke, segments, label, color in specs:
        draw_segmented_arc(
            draw,
            cx,
            cy,
            radius=radius,
            stroke=stroke,
            segment_count=segments,
            trail=4,
            progress=progress,
            color=color,
            show_head_dot=True,
        )
        if label is not None:
            f = font(int(radius * 1.15), bold=True)
            bbox = draw.textbbox((0, 0), label, font=f)
            tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
            draw.text(
                (cx - tw / 2, cy - th / 2 - 2),
                label,
                font=f,
                fill=color,
            )

    ImageDraw.Draw(img).text(
        (28, H - 42),
        "Progress with center value",
        font=font(18),
        fill=MUTED,
    )
    return img


def save_png(img: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    img.convert("RGB").save(path, "PNG", optimize=True)


def make_gif(path: Path) -> None:
    frames = []
    steps = [i / 24 for i in range(24)]
    for p in steps:
        # Composite both widgets into one looping demo.
        left = make_spinner_frame(p).resize((390, 260))
        right = make_value_frame((p + 0.35) % 1.0).resize((390, 260))
        canvas = Image.new("RGBA", (W, H), BG)
        canvas.paste(left, (0, 40))
        canvas.paste(right, (390, 40))
        caption = ImageDraw.Draw(canvas)
        caption.text(
            (28, H - 42),
            "segmented_progress_indicator",
            font=font(18),
            fill=MUTED,
        )
        frames.append(canvas.convert("P", palette=Image.ADAPTIVE))

    path.parent.mkdir(parents=True, exist_ok=True)
    frames[0].save(
        path,
        save_all=True,
        append_images=frames[1:],
        duration=50,
        loop=0,
        optimize=True,
    )


def main() -> None:
    SHOTS.mkdir(parents=True, exist_ok=True)
    save_png(make_spinner_frame(0.18), SHOTS / "spinner.png")
    save_png(make_value_frame(0.42), SHOTS / "with_value.png")
    make_gif(OUT / "demo.gif")
    print(f"Wrote {SHOTS / 'spinner.png'}")
    print(f"Wrote {SHOTS / 'with_value.png'}")
    print(f"Wrote {OUT / 'demo.gif'}")


if __name__ == "__main__":
    main()
