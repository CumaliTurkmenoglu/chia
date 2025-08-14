import fs from 'node:fs';
import path from 'node:path';

export type Reservation = {
  id: string;
  courtId: number; // 1..N
  dateISO: string; // YYYY-MM-DD
  startMinutes: number; // minutes since midnight
  durationMinutes: number; // e.g. 60
  name: string;
  email?: string;
  phone?: string;
  createdAt: string;
};

export type NewReservation = Omit<Reservation, 'id' | 'createdAt'>;

export interface IReservationStore {
  listByDate(dateISO: string): Promise<Reservation[]>;
  create(reservation: NewReservation): Promise<Reservation>;
}

class MemoryReservationStore implements IReservationStore {
  private reservations: Reservation[] = [];

  async listByDate(dateISO: string): Promise<Reservation[]> {
    return this.reservations.filter(r => r.dateISO === dateISO);
  }

  async create(reservation: NewReservation): Promise<Reservation> {
    const id = `${Date.now()}_${Math.random().toString(36).slice(2, 8)}`;
    const created: Reservation = {
      id,
      createdAt: new Date().toISOString(),
      ...reservation,
    };
    this.reservations.push(created);
    return created;
  }
}

class FileReservationStore implements IReservationStore {
  private filePath: string;
  private cache: Reservation[] | null = null;

  constructor(filePath: string) {
    this.filePath = filePath;
  }

  private ensureDir() {
    const dir = path.dirname(this.filePath);
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  }

  private readAll(): Reservation[] {
    if (this.cache) return this.cache;
    try {
      const raw = fs.readFileSync(this.filePath, 'utf-8');
      this.cache = JSON.parse(raw) as Reservation[];
    } catch (e) {
      this.cache = [];
    }
    return this.cache;
  }

  private writeAll(list: Reservation[]) {
    this.ensureDir();
    fs.writeFileSync(this.filePath, JSON.stringify(list, null, 2));
    this.cache = list;
  }

  async listByDate(dateISO: string): Promise<Reservation[]> {
    return this.readAll().filter(r => r.dateISO === dateISO);
  }

  async create(reservation: NewReservation): Promise<Reservation> {
    const id = `${Date.now()}_${Math.random().toString(36).slice(2, 8)}`;
    const created: Reservation = {
      id,
      createdAt: new Date().toISOString(),
      ...reservation,
    };
    const list = this.readAll();
    list.push(created);
    this.writeAll(list);
    return created;
  }
}

export function getReservationStore(): IReservationStore {
  // Use file store only in dev/local. On Vercel (production), use memory.
  if (process.env.NODE_ENV !== 'production') {
    const file = path.join(process.cwd(), '.data', 'reservations.json');
    return new FileReservationStore(file);
  }
  return new MemoryReservationStore();
}

export function hasConflict(existing: Reservation[], candidate: NewReservation): boolean {
  return existing.some(r => r.courtId === candidate.courtId && r.startMinutes === candidate.startMinutes);
}