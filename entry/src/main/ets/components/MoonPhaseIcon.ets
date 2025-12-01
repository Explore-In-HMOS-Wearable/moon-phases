@Component
export struct MoonPhaseIcon {
  @Prop @Require phase: number; // 1 to 8
  @Prop iconSize: number = 24;

  build() {
    Image($rawfile(`${this.getPhaseImage()}.png`))
      .width(this.iconSize)
      .height(this.iconSize)
      .objectFit(ImageFit.Contain)
      .interpolation(ImageInterpolation.High)
  }

  private getPhaseImage(): number {
    const imageIndices = [0, 15, 30, 45, 60, 75, 90, 105];
    let phaseIndex = ((this.phase - 1) % 8);

    if (phaseIndex < 0) { // Edge case: Negative input
      phaseIndex += 8;
    }

    return imageIndices[phaseIndex];
  }
}