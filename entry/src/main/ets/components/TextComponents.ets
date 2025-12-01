//* Unified Text Components for consistency and easier usage

@Component
export struct TextLargeTitle {
  @Prop @Require text: string;
  @Prop textAlign: TextAlign = TextAlign.Center;
  @Prop color: Resource = $r('app.color.text_primary');
  @Prop fontWeight: number | FontWeight = 500;
  @Prop textOpacity: number = 1.0;

  build() {
    Text(this.text)
      .fontSize($r('app.float.text_large_title'))
      .fontColor(this.color)
      .fontWeight(this.fontWeight)
      .textAlign(this.textAlign)
      .opacity(this.textOpacity)
  }
}

@Component
export struct TextTitle {
  @Prop @Require text: string;
  @Prop textAlign: TextAlign = TextAlign.Center;
  @Prop color: Resource = $r('app.color.text_primary');
  @Prop fontWeight: number | FontWeight = 500;
  @Prop textOpacity: number = 1.0;

  build() {
    Text(this.text)
      .fontSize($r('app.float.text_title'))
      .fontColor(this.color)
      .fontWeight(this.fontWeight)
      .textAlign(this.textAlign)
      .opacity(this.textOpacity)
  }
}

@Component
export struct TextBody {
  @Prop @Require text: string;
  @Prop textAlign: TextAlign = TextAlign.Center;
  @Prop color: Resource = $r('app.color.text_primary');
  @Prop fontWeight: number | FontWeight = 400;
  @Prop textOpacity: number = 1.0;

  build() {
    Text(this.text)
      .fontSize($r('app.float.text_body'))
      .fontColor(this.color)
      .fontWeight(this.fontWeight)
      .textAlign(this.textAlign)
      .opacity(this.textOpacity)
  }
}

@Component
export struct TextBodySecondary {
  @Prop @Require text: string;
  @Prop textAlign: TextAlign = TextAlign.Center;
  @Prop color: Resource = $r('app.color.text_secondary');
  @Prop fontWeight: number | FontWeight = 400;
  @Prop textOpacity: number = 1.0;

  build() {
    Text(this.text)
      .fontSize($r('app.float.text_body'))
      .fontColor(this.color)
      .fontWeight(this.fontWeight)
      .textAlign(this.textAlign)
      .opacity(this.textOpacity)
  }
}

@Component
export struct TextCaption {
  @Prop @Require text: string;
  @Prop textAlign: TextAlign = TextAlign.Center;
  @Prop color: Resource = $r('app.color.text_secondary');
  @Prop fontWeight: number | FontWeight = 500;
  @Prop textOpacity: number = 1.0;
  @Prop letterSpacing: number = 0;

  build() {
    Text(this.text)
      .fontSize($r('app.float.text_caption'))
      .fontColor(this.color)
      .fontWeight(this.fontWeight)
      .textAlign(this.textAlign)
      .opacity(this.textOpacity)
      .letterSpacing(this.letterSpacing)
  }
}

@Component
export struct TextSmall {
  @Prop @Require text: string;
  @Prop textAlign: TextAlign = TextAlign.Center;
  @Prop color: Resource = $r('app.color.text_disabled');
  @Prop fontWeight: number | FontWeight = 400;
  @Prop textOpacity: number = 1;

  build() {
    Text(this.text)
      .fontSize($r('app.float.text_small'))
      .fontColor(this.color)
      .fontWeight(this.fontWeight)
      .textAlign(this.textAlign)
      .opacity(this.textOpacity)
  }
}

@Component
export struct TextValue {
  @Prop @Require text: string;
  @Prop textAlign: TextAlign = TextAlign.Center;
  @Prop color: Resource = $r('app.color.text_primary');
  @Prop fontWeight: number | FontWeight = 500;
  @Prop textOpacity: number = 0.6;

  build() {
    Text(this.text)
      .fontSize($r('app.float.text_body'))
      .fontColor(this.color)
      .fontWeight(this.fontWeight)
      .textAlign(this.textAlign)
      .opacity(this.textOpacity)
  }
}

@Component
export struct TextCalendarDate {
  @Prop @Require text: string;
  @Prop isCurrentDate: boolean = false;
  @Prop isOtherMonth: boolean = false;

  build() {
    Text(this.text)
      .fontSize($r('app.float.text_date'))
      .fontColor(this.isOtherMonth ?
      $r('app.color.text_disabled') :
        (this.isCurrentDate ? $r('app.color.star_gold') : $r('app.color.text_primary')))
      .fontWeight(this.isCurrentDate ? 500 : 400)
      .textAlign(TextAlign.Center)
  }
}
