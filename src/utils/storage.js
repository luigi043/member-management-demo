// ---------------------------------------------------------------------------
// storage.js
// Thin persistence layer over localStorage with an in-memory fallback so the
// code also runs inside Node/Vitest (where localStorage is absent).
// Isolating storage here keeps the service layer testable and swappable
// (e.g. replace with a REST API later without touching callers).
// ---------------------------------------------------------------------------

const STORAGE_KEY = 'mmd.members';

// In-memory fallback used when localStorage is unavailable.
let memoryStore = null;

function hasLocalStorage() {
  try {
    return typeof localStorage !== 'undefined'
      && typeof localStorage.getItem === 'function'
      && typeof localStorage.setItem === 'function'
      && typeof localStorage.removeItem === 'function';
  } catch {
    return false;
  }
}

/** Read the full members array from storage. Returns [] on first run. */
export function load() {
  if (hasLocalStorage()) {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : [];
  }
  return memoryStore ? JSON.parse(memoryStore) : [];
}

/** Persist the full members array to storage. */
export function save(members) {
  const serialized = JSON.stringify(members);
  if (hasLocalStorage()) {
    localStorage.setItem(STORAGE_KEY, serialized);
  } else {
    memoryStore = serialized;
  }
}

/** Test helper: wipe all persisted data. */
export function clear() {
  if (hasLocalStorage()) {
    localStorage.removeItem(STORAGE_KEY);
  } else {
    memoryStore = null;
  }
}
