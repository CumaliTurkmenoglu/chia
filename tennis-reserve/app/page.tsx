"use client";

import { useEffect, useMemo, useState } from 'react';
import { addDays, formatDateISO, generateDailySlots, toTimeLabel } from '@/lib/time';

const NUM_COURTS = 3;
const SLOT_DURATION_MINUTES = 60;

type Reservation = {
  id: string;
  courtId: number;
  dateISO: string;
  startMinutes: number;
  durationMinutes: number;
  name: string;
};

function todayISO() {
  const d = new Date();
  d.setHours(0, 0, 0, 0);
  return formatDateISO(d);
}

function buildDateRange(startISO: string, days: number): string[] {
  const start = new Date(startISO);
  const list: string[] = [];
  for (let i = 0; i < days; i++) {
    list.push(formatDateISO(addDays(start, i)));
  }
  return list;
}

export default function Page() {
  const [selectedDate, setSelectedDate] = useState<string>(todayISO());
  const [reservations, setReservations] = useState<Reservation[]>([]);
  const [selectedCourt, setSelectedCourt] = useState<number>(1);
  const [pending, setPending] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const dates = useMemo(() => buildDateRange(selectedDate, 7), [selectedDate]);
  const slots = useMemo(() => generateDailySlots(), []);

  useEffect(() => {
    const controller = new AbortController();
    async function load() {
      try {
        const res = await fetch(`/api/reservations?date=${selectedDate}`, { signal: controller.signal, cache: 'no-store' });
        const json = await res.json();
        setReservations(json.reservations ?? []);
      } catch (e) {
        // ignore
      }
    }
    load();
    return () => controller.abort();
  }, [selectedDate]);

  function isReserved(courtId: number, startMinutes: number): Reservation | undefined {
    return reservations.find(r => r.courtId === courtId && r.startMinutes === startMinutes);
  }

  async function submitReservation(startMinutes: number, name: string, email?: string, phone?: string) {
    setPending(true);
    setError(null);
    setMessage(null);
    try {
      const res = await fetch('/api/reservations', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          courtId: selectedCourt,
          dateISO: selectedDate,
          startMinutes,
          durationMinutes: SLOT_DURATION_MINUTES,
          name,
          email,
          phone,
        }),
      });
      const json = await res.json();
      if (!res.ok) {
        throw new Error(json.error || 'Failed to create reservation');
      }
      setMessage(`Reserved ${toTimeLabel(startMinutes)} on Court ${selectedCourt} for ${name}.`);
      // refresh reservations list
      const listRes = await fetch(`/api/reservations?date=${selectedDate}`, { cache: 'no-store' });
      const listJson = await listRes.json();
      setReservations(listJson.reservations ?? []);
    } catch (e: any) {
      setError(e.message || 'Something went wrong');
    } finally {
      setPending(false);
    }
  }

  return (
    <div className="space-y-6">
      <header className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold tracking-tight">Tennis Court Reservations</h1>
          <p className="text-gray-600">Select a date and court, then choose an available time slot.</p>
        </div>
        <a className="btn btn-ghost" href="https://vercel.com" target="_blank" rel="noreferrer">Deploy on Vercel</a>
      </header>

      <section className="card p-4">
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
          <div>
            <label className="label" htmlFor="date">Date</label>
            <input
              id="date"
              className="input"
              type="date"
              value={selectedDate}
              onChange={(e) => setSelectedDate(e.target.value)}
              min={todayISO()}
            />
          </div>
          <div>
            <label className="label" htmlFor="court">Court</label>
            <select
              id="court"
              className="input"
              value={selectedCourt}
              onChange={(e) => setSelectedCourt(Number(e.target.value))}
            >
              {Array.from({ length: NUM_COURTS }, (_, i) => i + 1).map(court => (
                <option key={court} value={court}>Court {court}</option>
              ))}
            </select>
          </div>
        </div>
      </section>

      {message && (
        <div className="rounded-md bg-green-50 border border-green-200 p-3 text-green-900">{message}</div>
      )}
      {error && (
        <div className="rounded-md bg-red-50 border border-red-200 p-3 text-red-900">{error}</div>
      )}

      <section className="card p-4">
        <h2 className="text-lg font-semibold mb-3">Available time slots</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3">
          {slots.map((start) => {
            const reserved = isReserved(selectedCourt, start);
            return (
              <SlotCard
                key={start}
                startMinutes={start}
                reserved={!!reserved}
                reservedBy={reserved?.name}
                disabled={pending}
                onSubmit={(name, email, phone) => submitReservation(start, name, email, phone)}
              />
            );
          })}
        </div>
      </section>

      <footer className="text-xs text-gray-500">
        Demo-only storage. Reservations reset on redeploy in production. For persistent storage, connect a database (e.g. Vercel Postgres).
      </footer>
    </div>
  );
}

function SlotCard({
  startMinutes,
  reserved,
  reservedBy,
  disabled,
  onSubmit,
}: {
  startMinutes: number;
  reserved: boolean;
  reservedBy?: string;
  disabled?: boolean;
  onSubmit: (name: string, email?: string, phone?: string) => void;
}) {
  const [open, setOpen] = useState(false);
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [phone, setPhone] = useState('');

  useEffect(() => {
    if (reserved) setOpen(false);
  }, [reserved]);

  return (
    <div className="border rounded-lg p-3">
      <div className="flex items-center justify-between">
        <div className="font-medium">{toTimeLabel(startMinutes)}</div>
        {reserved ? (
          <span className="text-sm text-gray-500">Reserved{reservedBy ? ` by ${reservedBy}` : ''}</span>
        ) : (
          <button
            className="btn btn-primary"
            disabled={disabled}
            onClick={() => setOpen((v) => !v)}
          >
            {open ? 'Close' : 'Book'}
          </button>
        )}
      </div>
      {!reserved && open && (
        <div className="mt-3 space-y-2">
          <div>
            <label className="label" htmlFor={`name-${startMinutes}`}>Name</label>
            <input id={`name-${startMinutes}`} className="input" value={name} onChange={(e) => setName(e.target.value)} placeholder="Your full name" />
          </div>
          <div className="grid grid-cols-1 gap-2 sm:grid-cols-2">
            <div>
              <label className="label" htmlFor={`email-${startMinutes}`}>Email (optional)</label>
              <input id={`email-${startMinutes}`} className="input" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="you@example.com" />
            </div>
            <div>
              <label className="label" htmlFor={`phone-${startMinutes}`}>Phone (optional)</label>
              <input id={`phone-${startMinutes}`} className="input" value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="(555) 555-5555" />
            </div>
          </div>
          <div className="flex gap-2">
            <button
              className="btn btn-primary"
              disabled={disabled || name.trim().length < 2}
              onClick={() => onSubmit(name.trim(), email.trim() || undefined, phone.trim() || undefined)}
            >
              Confirm
            </button>
            <button className="btn btn-ghost" onClick={() => setOpen(false)}>Cancel</button>
          </div>
        </div>
      )}
    </div>
  );
}