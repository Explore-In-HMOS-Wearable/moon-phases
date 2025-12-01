import { MoonPhaseIcon } from '../components/MoonPhaseIcon';
import { MoonPhaseLottie } from '../components/MoonPhaseLottie';
import { TextBodySecondary, TextSmall, TextTitle } from '../components/TextComponents';
import { getCountdownText, MoonPhaseData } from '../utils/MoonCalculator';

@Component
export struct MoonPage {
  @Prop @Require moonData: MoonPhaseData;

  build() {
    Column() {
      Row() {
        Column() {
          MoonPhaseIcon({ phase: 5, iconSize: 20 })
          TextSmall({ text: getCountdownText(this.moonData.nextFullMoon) }).margin({ top: 2 })
        }
        .margin({ left: $r('app.float.spacing_small') })
        .width(40)
        .height(40)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius($r('app.float.card_radius'))
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)

        Blank()

        MoonPhaseLottie({
          moonPhase: this.moonData.phase,
          canvasWidth: $r('app.float.moon_size'),
          canvasHeight: $r('app.float.moon_size')
        })

        Blank()

        Column() {
          MoonPhaseIcon({ phase: 1, iconSize: 20 })
          TextSmall({ text: getCountdownText(this.moonData.nextNewMoon) }).margin({ top: 2 })
        }
        .margin({ right: $r('app.float.spacing_small') })
        .width(40)
        .height(40)
        .backgroundColor($r('app.color.card_background'))
        .borderRadius($r('app.float.card_radius'))
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .alignItems(VerticalAlign.Bottom)

      Column() {
        Row() {
          MoonPhaseIcon({ phase: this.moonData.phaseIcon })
          TextTitle({ text: ` ${this.moonData.phaseName}` })
        }

        TextBodySecondary({ text: `${this.moonData.illumination}% Illuminated` })
        TextBodySecondary({ text: `Day ${this.moonData.age.toFixed(1)}` })
        TextBodySecondary({ text: `${Math.round(this.moonData.distance).toLocaleString()} km` })

        Blank().height($r('app.float.spacing_xs'))

        Row() {
          TextSmall({ text: '   Calendar' })
          Image($rawfile(`chevron_right.png`)).width(16).height(16)
        }
      }
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }
}