/// Offline algorithmic moon phase calculations

export interface MoonPhaseData {
  phase: number;
  illumination: number;
  age: number;
  phaseName: string;
  phaseIcon: number;
  distance: number;
  nextFullMoon: Date;
  nextNewMoon: Date;
  isGrowing: boolean;
}

export interface PhaseInfo {
  name: string;
  icon: number;
}

interface PhaseBoundary {
  min: number;
  max: number;
  name: string;
  icon: number;
}

const KNOWN_NEW_MOON = new Date('2000-01-06T18:14:00Z');
const SYNODIC_MONTH = 29.530588670; // Days in lunar cycle
const ANOMALISTIC_MONTH = 27.55455; // Days for moon to orbit from perigee to perigee
const LUNAR_PERIGEE = 356500; // Closest distance from Earth in km
const LUNAR_APOGEE = 406700; // Farthest distance from Earth in km

export function calculateMoonPhase(date: Date): MoonPhaseData {
  const jd = toJulianDate(date);
  const daysSinceNewMoon = getMoonAge(jd);
  const phase = (daysSinceNewMoon / SYNODIC_MONTH) % 1;
  const illumination = getMoonIllumination(daysSinceNewMoon);
  const distance = getMoonDistance(jd);
  const phaseInfo = getPhaseInfo(phase);

  const nextFullMoon = getNextPhaseDate(date, 0.5);
  const nextNewMoon = getNextPhaseDate(date, 0.0);

  const isGrowing = phase > 0 && phase < 0.5; //Waxing vs Waning

  return {
    phase,
    illumination,
    age: daysSinceNewMoon,
    phaseName: phaseInfo.name,
    phaseIcon: phaseInfo.icon,
    distance,
    nextFullMoon,
    nextNewMoon,
    isGrowing
  };
}

export function toJulianDate(date: Date): number {
  const year = date.getUTCFullYear();
  const month = date.getUTCMonth() + 1; // JS months are 0 based
  const day = date.getUTCDate();
  const hours = date.getUTCHours();
  const minutes = date.getUTCMinutes();
  const seconds = date.getUTCSeconds();

  const dayFraction = (hours + minutes / 60 + seconds / 3600) / 24;

  let a = Math.floor((14 - month) / 12);
  let y = year + 4800 - a;
  let m = month + 12 * a - 3;

  let jdn =
    day + Math.floor((153 * m + 2) / 5) + 365 * y + Math.floor(y / 4) - Math.floor(y / 100) + Math.floor(y / 400) -
      32045;

  return jdn + dayFraction;
}

export function getMoonAge(julianDate: number): number {
  const knownNewMoonJD = toJulianDate(KNOWN_NEW_MOON);
  const daysSinceKnown = julianDate - knownNewMoonJD;
  const lunarCycles = Math.floor(daysSinceKnown / SYNODIC_MONTH);
  const age = daysSinceKnown - (lunarCycles * SYNODIC_MONTH);

  return age >= 0 ? age : age + SYNODIC_MONTH;
}

export function getMoonIllumination(moonAge: number): number {
  const phase = moonAge / SYNODIC_MONTH;
  const illumination = (1 - Math.cos(phase * 2 * Math.PI)) * 50;

  return Math.round(Math.max(0, Math.min(100, illumination)));
}

export function getPhaseInfo(phase: number): PhaseInfo {
  const normalizedPhase = ((phase % 1) + 1) % 1; // Normalize to 0-1

  const phases: PhaseBoundary[] = [
    { min: 0.0, max: 0.02, name: 'New Moon', icon: 1 },
    { min: 0.02, max: 0.23, name: 'Waxing Crescent', icon: 2 },
    { min: 0.23, max: 0.27, name: 'First Quarter', icon: 3 },
    { min: 0.27, max: 0.48, name: 'Waxing Gibbous', icon: 4 },
    { min: 0.48, max: 0.52, name: 'Full Moon', icon: 5 },
    { min: 0.52, max: 0.73, name: 'Waning Gibbous', icon: 6 },
    { min: 0.73, max: 0.77, name: 'Last Quarter', icon: 7 },
    { min: 0.77, max: 0.98, name: 'Waning Crescent', icon: 8 },
    { min: 0.98, max: 1.0, name: 'New Moon', icon: 1 }, // Back to new moon
  ];

  for (const p of phases) {
    if (normalizedPhase >= p.min && normalizedPhase < p.max) {
      const result: PhaseInfo = { name: p.name, icon: p.icon};
      return result;
    }
  }

  const defaultResult: PhaseInfo = { name: 'New Moon', icon: 1};
  return defaultResult; // Fallback
}

export function getNextPhaseDate(date: Date, targetPhase: number): Date {
  const jd = toJulianDate(date);
  const currentAge = getMoonAge(jd);
  const currentPhase = currentAge / SYNODIC_MONTH;

  let daysUntilPhase: number;

  if (targetPhase > currentPhase) {
    daysUntilPhase = (targetPhase - currentPhase) * SYNODIC_MONTH;
  } else {
    daysUntilPhase = ((1 - currentPhase) + targetPhase) * SYNODIC_MONTH;
  }

  if (daysUntilPhase < 0.5) { // Edge case
    daysUntilPhase += SYNODIC_MONTH;
  }

  const targetDate = new Date(date.getTime() + daysUntilPhase * 24 * 60 * 60 * 1000);

  return targetDate;
}

export function getMoonDistance(julianDate: number): number {
  const referencePerigee = toJulianDate(new Date('2000-01-01T00:00:00Z'));
  const daysSincePerigee = julianDate - referencePerigee;

  const anomalisticPhase = (daysSincePerigee / ANOMALISTIC_MONTH) % 1;

  const distanceVariation = (LUNAR_APOGEE - LUNAR_PERIGEE) / 2;
  const meanDistance = (LUNAR_APOGEE + LUNAR_PERIGEE) / 2;

  const distance = meanDistance - distanceVariation * Math.cos(anomalisticPhase * 2 * Math.PI);

  return Math.round(distance);
}

export function getCountdownText(nextPhaseDate: Date): string {
  const now = new Date();
  const msUntil = nextPhaseDate.getTime() - now.getTime();
  const daysUntil = Math.ceil(msUntil / (1000 * 60 * 60 * 24));

  if (daysUntil === 0) {
    return 'Today';
  } else if (daysUntil === 1) {
    return 'Tomorrow';
  } else if (daysUntil < 0) {
    return 'Calculating...'
  } else {
    return `${daysUntil} days`;
  }
}
