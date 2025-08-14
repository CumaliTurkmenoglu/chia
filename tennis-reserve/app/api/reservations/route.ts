import { NextRequest, NextResponse } from 'next/server';
import { getReservationStore, hasConflict } from '@/lib/reservationsStore';
import { parseISODate } from '@/lib/time';

export const dynamic = 'force-dynamic';

export async function GET(req: NextRequest) {
  const { searchParams } = new URL(req.url);
  const dateISO = searchParams.get('date');
  if (!dateISO) {
    return NextResponse.json({ error: 'Missing date param (YYYY-MM-DD)' }, { status: 400 });
  }
  // validate date
  try {
    parseISODate(dateISO);
  } catch {
    return NextResponse.json({ error: 'Invalid date format' }, { status: 400 });
  }

  const store = getReservationStore();
  const list = await store.listByDate(dateISO);
  return NextResponse.json({ reservations: list });
}

export async function POST(req: NextRequest) {
  const store = getReservationStore();
  const data = await req.json().catch(() => null);
  if (!data) return NextResponse.json({ error: 'Invalid JSON' }, { status: 400 });

  const { courtId, dateISO, startMinutes, durationMinutes, name, email, phone } = data as Record<string, unknown>;

  if (
    typeof courtId !== 'number' ||
    typeof dateISO !== 'string' ||
    typeof startMinutes !== 'number' ||
    typeof durationMinutes !== 'number' ||
    typeof name !== 'string' || name.trim().length < 2
  ) {
    return NextResponse.json({ error: 'Missing or invalid fields' }, { status: 400 });
  }

  const existing = await store.listByDate(dateISO);
  if (hasConflict(existing, { courtId, dateISO, startMinutes, durationMinutes, name, email: email as string | undefined, phone: phone as string | undefined })) {
    return NextResponse.json({ error: 'Time slot already reserved for this court' }, { status: 409 });
  }

  const created = await store.create({ courtId, dateISO, startMinutes, durationMinutes, name, email: email as string | undefined, phone: phone as string | undefined });
  return NextResponse.json({ reservation: created }, { status: 201 });
}