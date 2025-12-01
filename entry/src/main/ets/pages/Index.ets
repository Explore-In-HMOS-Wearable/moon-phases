import { calculateMoonPhase, MoonPhaseData } from '../utils/MoonCalculator';
import { CalendarPage } from './CalendarPage';
import { MoonPage } from './MoonPage';

@Entry
@Component
struct Index {
  @State currentPageIndex: number = 0;
  @State currentDate: Date = new Date();
  @State moonData: MoonPhaseData = calculateMoonPhase(new Date());
  private swiperController: SwiperController = new SwiperController();

  build() {
    Stack() {
      Swiper(this.swiperController) {
        MoonPage({ moonData: this.moonData })

        CalendarPage()
      }
      .loop(false)
      .indicator(new DotIndicator().color($r('app.color.moon_shadow_light'))
        .selectedColor($r('app.color.moon_surface')))
      .duration(300)
      .curve(Curve.EaseInOut)
      .onChange((index: number) => {
        this.currentPageIndex = index;
      })
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_color'))
  }
}