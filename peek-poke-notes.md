`POKE`s are straight into the VIC chip’s 16 registers at `$9000–$900F` (decimal `36864–36879`). The game is using them for **screen colors/video base** and **sound effects**. ([Wikipedia][1])

### Video / screen setup

* **`POKE 36869,192` / `POKE 36869,194`** → register **$9005**
  This sets the **screen memory base** and the **character (font) memory base** (it’s the “where is video RAM / where is charset” selector). `192=$C0` vs `194=$C2` means “same video base, slightly different character base.” ([Wikipedia][1])

* **`POKE 36879,25`**, later **`POKE 36879,78`**, later **`POKE 36879,8`** → register **$900F**
  This controls **background color, border color, and reverse-video** (a single packed byte). The game is basically switching “palette mood” between intro/title/game/end states. ([Wikipedia][1])

### Sound effects (the “sonic protection” + explosion stuff)

* **`POKE 36878,15`** then later **`POKE 36878,0`** → register **$900E**
  Low bits are **volume** (0–15). High bits are **auxiliary color**. So `15` is “volume full, aux color 0”; `0` mutes. ([Wikipedia][1])

* **`POKE 36876,210`** → register **$900C**
  Oscillator 3 frequency + enable bit (bit 7). That `210` value has the enable bit set, so it turns the voice on at some pitch. ([Wikipedia][1])

* **`POKE 36877,254`** and later sweeping `POKE 36877,X` → register **$900D**
  Noise generator frequency + enable. `254` is basically “noise on, very high.” Sweeping it makes that classic harsh hiss / burst. ([Wikipedia][1])

* **`POKE 36874,X`** inside the explosion loop → register **$900A**
  Oscillator 1 frequency + enable. They’re modulating tone alongside the noise + volume ramp to make a more dramatic “boom/engine” effect. ([Wikipedia][1])

If you want, I can annotate *exactly* which moments in the plot correspond to each effect (title, sonic-room timer death, hyperdrive explosion/escape sequence), but mechanically: **$9005/$900F = display setup**, **$900A/$900C/$900D/$900E = audio synth + volume**.

[1]: https://en.wikipedia.org/wiki/MOS_Technology_VIC?utm_source=chatgpt.com "MOS Technology VIC"
