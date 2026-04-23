# Design System Specification: High-Density Laboratory

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Digital Observatory."** 

This system moves away from the "flat dashboard" trope and toward a high-end, editorial laboratory aesthetic. It is designed to feel like a precision instrument—crystalline, responsive, and intellectually dense. We achieve this by rejecting heavy containers and standard grids in favor of **intentional asymmetry** and **tonal depth**. The layout should feel like a series of data-objects suspended in a clean, pressurized environment. By utilizing extreme whitespace and varied typographic scales, we create a "Solar High-Density" experience that remains breathable despite the complexity of the data.

---

## 2. Colors & Surface Philosophy

The color palette is rooted in a light-spectrum "Solar" base, utilizing high-chroma accents to guide the eye through dense information environments.

### The Palette (Material Scale)
- **Base Surface:** `surface` (#f7f9fb)
- **Primary Action:** `primary` (#004ac6) / `primary_container` (#2563eb)
- **Data Accents:** `secondary` (#4b41e1) / `tertiary` (#824500)
- **Status/Alert:** `error` (#ba1a1a) / `tertiary_fixed` (#ffdcc3)

### The "No-Line" Rule
Standard 1px borders are strictly prohibited for layout sectioning. Structural boundaries must be achieved through:
1.  **Background Shifts:** Transitioning from `surface` to `surface_container_low`.
2.  **Negative Space:** Using the spacing scale to create implicit gutters.
3.  **Tonal Transitions:** A 0.5px `outline_variant` (#c3c6d7) at 20% opacity is only permitted for interactive boundaries, never for layout separation.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. We use "Tonal Layering" to define importance:
*   **Level 0 (Foundation):** `surface` (#f7f9fb) – The canvas.
*   **Level 1 (Sub-sections):** `surface_container_low` (#f2f4f6) – Used for grouping secondary data.
*   **Level 2 (Active Cards):** `surface_container_lowest` (#ffffff) – High-contrast "paper" layers that pop against the gray base.
*   **Level 3 (Interactive Floating):** Glassmorphism surfaces. Use `surface_container_lowest` at 70% opacity with a `backdrop-filter: blur(20px)`.

### Signature Textures
Main CTAs and critical data headers should utilize a subtle **"Solar Flare" gradient**: 
*   From `primary` (#004ac6) to `primary_container` (#2563eb) at a 135-degree angle. This provides a tactile "glow" that feels engineered rather than painted.

---

## 3. Typography: Technical Clarity
We use **Inter** exclusively. To achieve an editorial look, we play with extreme contrast in weight and letter-spacing.

*   **Display (Large Metrics):** `display-lg` (3.5rem). Semi-bold. Letter-spacing: `-0.02em`. Used for "Hero" data points.
*   **Headlines (Section Headers):** `headline-sm` (1.5rem). Bold. Wide-tracked (`letter-spacing: 0.05em`). All-caps for high-density technical labels.
*   **Titles (Card Labels):** `title-md` (1.125rem). Medium weight. Provides a "Technical Report" feel.
*   **Body (Data & Content):** `body-md` (0.875rem). Regular weight. High line-height (1.6) to ensure legibility in dense tables.
*   **Labels (Metadata):** `label-sm` (0.6875rem). Bold. Used for status tags and micro-data.

---

## 4. Elevation & Depth

### The Layering Principle
Do not use shadows to create hierarchy; use **tone**. A card using `surface_container_lowest` sitting on a `surface_container_low` background creates a natural, sophisticated lift.

### Ambient Shadows
Shadows are reserved only for "floating" elements (Modals, Hovered Cards, Tooltips). 
*   **Value:** `0px 20px 40px rgba(0, 74, 198, 0.05)`. 
*   Note the blue tint in the shadow—this mimics the "Command Blue" light refraction, making the UI feel cohesive.

### Glassmorphism & Depth
For sidebars or floating control panels, use the **Glass Fallback**:
*   `Background: rgba(255, 255, 255, 0.6)`
*   `Backdrop-filter: blur(20px)`
*   `Border: 0.5px solid rgba(226, 232, 240, 0.5)`

---

## 5. Components

### Buttons
*   **Primary:** Gradient fill (`primary` to `primary_container`), `md` corner radius (0.375rem). 0.5px outer glow on hover using `primary_fixed`.
*   **Secondary:** Ghost style. No fill, `outline_variant` at 20% opacity. Text uses `primary`.
*   **Tertiary:** Text-only, `label-md` style, all-caps.

### Cards & Lists
*   **The Divider Ban:** Vertical lines are forbidden. Separate list items using 12px of vertical padding and a subtle hover state shift to `surface_container_high`.
*   **Nesting:** High-priority cards use `surface_container_lowest` (#ffffff) with a 0.5px `outline_variant` border.

### Input Fields
*   **Style:** Minimalist. No background fill. Only a bottom border using `outline_variant`.
*   **Focus State:** The bottom border transforms into the `primary` color with a 2px "soft glow" underneath.

### Data Chips
*   **Status:** Use `tertiary_container` for alerts and `primary_fixed` for active states. 
*   **Shape:** `full` radius (pill-shaped). Typography: `label-sm` bold.

### Custom Component: The "Command Module"
A large-scale header component for dashboards. It should use `surface_bright` and feature a 0.5px bottom "Ghost Border" to separate the controls from the data scroll, maintaining a constant "Laboratory" anchor.

---

## 6. Do’s and Don'ts

### Do:
*   **Use Asymmetry:** Place critical metrics off-center to create a dynamic, editorial feel.
*   **Embrace High Density:** It is okay to have many elements on screen, provided they are aligned to a strict 8px baseline grid and separated by tonal shifts.
*   **Tint Your Neutrals:** Always ensure your grays have a hint of blue (`#F8FAFC`) to stay within the "Solar" spectrum.

### Don’t:
*   **Don’t use 100% Black:** Text should never be `#000000`. Use `on_surface` (#191c1e) for optimal premium contrast.
*   **Don’t use Drop Shadows on Cards:** Rely on the Tonal Layering Principle. Only Modals get shadows.
*   **Don’t use Standard Grids:** Try overlapping a chart over a section boundary to create visual "soul" and depth.