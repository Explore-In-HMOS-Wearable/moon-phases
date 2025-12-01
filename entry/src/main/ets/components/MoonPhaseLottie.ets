import lottie, { AnimationItem } from '@ohos/lottie';

@Component
export struct MoonPhaseLottie {
  @Prop @Require moonPhase: number; // 0-1, ex: 0 is new, 0.5 is full, 1 is back to new
  @Prop canvasWidth: Resource | number = 200;
  @Prop canvasHeight: Resource | number = 200;
  private animationItem: AnimationItem | null = null;
  private animationName: string | null = `moonPhase_${Date.now()}`;
  private hasStoppedManually: boolean = false; // Flag to prevent inf loop
  // Canvas context setup
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings);

  aboutToDisappear(): void {
    if (this.animationName) {
      lottie.destroy(this.animationName);
    }
    this.animationName = null;
  }

  build() {
    Canvas(this.canvasContext)
      .width(this.canvasWidth)
      .height(this.canvasHeight)
      .backgroundColor(Color.Transparent)
      .onReady(() => {
        this.canvasContext.imageSmoothingEnabled = true;
        this.canvasContext.imageSmoothingQuality = 'medium';

        const targetFrame = this.getTargetFrame();

        // Loading with initial segment is cleaner for this case. Prevents frame overshooting
        this.animationItem = lottie.loadAnimation({
          container: this.canvasContext,
          renderer: 'canvas',
          loop: false,
          autoplay: false,
          name: this.animationName,
          contentMode: 'Contain',
          path: 'rawfile/moon-phases.json',
          initialSegment: [0, targetFrame]
        });

        this.animationItem?.addEventListener('DOMLoaded', () => {
          this.animationItem?.setSpeed(1.2);
          this.animationItem?.play();
        });

        // Ease-in effect near the end frame
        this.animationItem?.addEventListener('enterFrame', () => {
          if (this.hasStoppedManually) {
            return;
          }

          const currentFrame = this.animationItem?.currentFrame ?? 0;

          // Stop manually when we reach end (or exceed in edge cases)
          if (currentFrame >= targetFrame - 0.5) {
            this.hasStoppedManually = true;
            this.animationItem?.pause();
            this.animationItem?.goToAndStop(targetFrame, true);
            return;
          }

          const progress = currentFrame / targetFrame;

          // When at last %30, start to slow down (ease-in effect)

          if (progress > 0.7) {
            const easeInFactor = 1 - ((progress - 0.7) / 0.3); // Goes from 1 to 0
            const newSpeed = 0.2 + (easeInFactor); // Speed goes from 1 to 0.2
            this.animationItem?.setSpeed(newSpeed);
          }
        });
      })
  }

  private getTargetFrame(): number {
    return Math.max(1, Math.min(119, Math.floor(this.moonPhase * 120)));
  }
}