import { MoonPhaseIcon } from '../components/MoonPhaseIcon';
import { TextCaption, TextSmall } from '../components/TextComponents';
import { calculateMoonPhase } from '../utils/MoonCalculator';

interface CalendarDay {
  date: Date;
  dayNumber: string;
  monthName: string;
  phaseIcon: number;
  isToday: boolean;
}

@Component
export struct CalendarPage {
  @State calendarDays: CalendarDay[] = [];

  aboutToAppear(): void {
    this.generateCalendarDays();
  }

  build() {
    Column() {
      TextCaption({ text: 'NEXT 14 DAYS', letterSpacing: 1 })
        .margin({ top: $r('app.float.spacing_small'), bottom: $r('app.float.spacing_xs') })

      Column({ space: $r('app.float.spacing_xs') }) {
        // Row 1
        Row({ space: $r('app.float.spacing_xs') }) {
          ForEach(this.getRowDays(0), (day: CalendarDay) => {
            this.GridCell(day)
          }, (day: CalendarDay) => day.date.getTime().toString())
        }
        .justifyContent(FlexAlign.SpaceEvenly)

        // Row 2
        Row({ space: $r('app.float.spacing_xs') }) {
          ForEach(this.getRowDays(1), (day: CalendarDay) => {
            this.GridCell(day)
          }, (day: CalendarDay) => day.date.getTime().toString())
        }
        .justifyContent(FlexAlign.SpaceEvenly)

        // Row 3
        Row({ space: $r('app.float.spacing_xs') }) {
          ForEach(this.getRowDays(2), (day: CalendarDay) => {
            this.GridCell(day)
          }, (day: CalendarDay) => day.date.getTime().toString())
        }
        .justifyContent(FlexAlign.SpaceEvenly)

        // Row 4
        Row({ space: $r('app.float.spacing_xs') }) {
          ForEach(this.getRowDays(3), (day: CalendarDay) => {
            this.GridCell(day)
          }, (day: CalendarDay) => day.date.getTime().toString())
        }
        .justifyContent(FlexAlign.SpaceEvenly)
      }
      .width('95%')
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  GridCell(day: CalendarDay) {
    Column() {
      MoonPhaseIcon({ phase: day.phaseIcon, iconSize: 28 })
      TextSmall({ text: `${day.monthName} ${day.dayNumber}` }).margin({ top: 2 })
    }
    .width(44)
    .height(44)
    .backgroundColor(day.isToday ? $r('app.color.card_background') : Color.Transparent)
    .borderRadius(8)
    .justifyContent(FlexAlign.Center)
    .border(day.isToday ? { width: 1, color: $r('app.color.moon_surface') } : undefined)
  }

  private generateCalendarDays(): void {
    const days: CalendarDay[] = [];
    const today = new Date();
    const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    for (let i = 0; i < 14; i++) {
      const date = new Date(today);
      date.setDate(today.getDate() + i);

      const moonData = calculateMoonPhase(date);

      days.push({
        date: date,
        dayNumber: date.getDate().toString().padStart(2, '0'),
        monthName: monthNames[date.getMonth()],
        phaseIcon: moonData.phaseIcon,
        isToday: i === 0
      });
    }
    this.calendarDays = days;
  }

  private getRowDays(rowIndex: number): CalendarDay[] {
    const startIndex = rowIndex * 4;
    return this.calendarDays.slice(startIndex, startIndex + 4);
  }
}