export const OPEN_HOUR_24 = 7; // 7:00
export const CLOSE_HOUR_24 = 22; // 22:00
export const SLOT_MINUTES = 60;

export function formatDateISO(date: Date): string {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, '0');
  const d = String(date.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

export function parseISODate(iso: string): Date {
  const [y, m, d] = iso.split('-').map(Number);
  const date = new Date();
  date.setFullYear(y);
  date.setMonth(m - 1);
  date.setDate(d);
  date.setHours(0, 0, 0, 0);
  return date;
}

export function toTimeLabel(minutesSinceMidnight: number): string {
  const hours = Math.floor(minutesSinceMidnight / 60);
  const minutes = minutesSinceMidnight % 60;
  const ampm = hours >= 12 ? 'PM' : 'AM';
  const h12 = ((hours + 11) % 12) + 1;
  return `${h12}:${String(minutes).padStart(2, '0')} ${ampm}`;
}

export function generateDailySlots(): number[] {
  const slots: number[] = [];
  for (let h = OPEN_HOUR_24; h < CLOSE_HOUR_24; h++) {
    slots.push(h * 60);
  }
  return slots;
}

export function addDays(date: Date, days: number): Date {
  const d = new Date(date);
  d.setDate(d.getDate() + days);
  return d;
}