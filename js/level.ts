export interface Coords {
  readonly x: number;
  readonly y: number;
}

export interface Platform extends Coords {
  type: 'rotater' | 'rotater_small' | 'trampoline' | 'touch';
  rotation?: number;
  bounce?: number;
}

export interface Level {
  spawn: Coords
  goal: Coords
  platforms: readonly Platform[];
}
