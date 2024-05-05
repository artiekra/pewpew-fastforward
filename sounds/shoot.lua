require"/dynamic/ppol/.lua"
require"helpers/sound_parser"

sound = parseSound("https://pewpew.live/jfxr/#%7B%22_version%22%3A1%2C%22_name%22%3A%22Laser%2Fshoot%204%22%2C%22_locked%22%3A%5B%5D%2C%22sampleRate%22%3A44100%2C%22attack%22%3A0%2C%22sustain%22%3A0.03864843123629602%2C%22sustainPunch%22%3A0%2C%22decay%22%3A0.03436250016386322%2C%22tremoloDepth%22%3A26%2C%22tremoloFrequency%22%3A22.76515137304129%2C%22frequency%22%3A3222.243443733863%2C%22frequencySweep%22%3A-1900%2C%22frequencyDeltaSweep%22%3A-1000%2C%22repeatFrequency%22%3A0%2C%22frequencyJump1Onset%22%3A33%2C%22frequencyJump1Amount%22%3A0%2C%22frequencyJump2Onset%22%3A66%2C%22frequencyJump2Amount%22%3A0%2C%22harmonics%22%3A0%2C%22harmonicsFalloff%22%3A0.5%2C%22waveform%22%3A%22sawtooth%22%2C%22interpolateNoise%22%3Atrue%2C%22vibratoDepth%22%3A4.6%2C%22vibratoFrequency%22%3A19%2C%22squareDuty%22%3A40%2C%22squareDutySweep%22%3A-45%2C%22flangerOffset%22%3A8%2C%22flangerOffsetSweep%22%3A1%2C%22bitCrush%22%3A16%2C%22bitCrushSweep%22%3A0%2C%22lowPassCutoff%22%3A22050%2C%22lowPassCutoffSweep%22%3A0%2C%22highPassCutoff%22%3A0%2C%22highPassCutoffSweep%22%3A0%2C%22compression%22%3A1%2C%22normalization%22%3Atrue%2C%22amplification%22%3A10%7D")

-- debug_print_contents(sound)
-- [TODO: write raw data, stop using sound_parser]
sounds = {
    sound
}
