/**
 * Neu/AIE Core Types
 *
 * Emulates the Neu type system in TypeScript:
 * - Algebraic data types via discriminated unions
 * - Engine classification (Synthesis / Analysis / Transformation)
 * - Effect tracking via branded types
 * - Result/Option instead of exceptions/null
 */

// ─── Result & Option (from Rust/Haskell) ───

export type Result<T, E> =
  | { readonly kind: "ok"; readonly value: T }
  | { readonly kind: "err"; readonly error: E };

export type Option<T> =
  | { readonly kind: "some"; readonly value: T }
  | { readonly kind: "none" };

export const Ok = <T>(value: T): Result<T, never> => ({
  kind: "ok",
  value,
});

export const Err = <E>(error: E): Result<never, E> => ({
  kind: "err",
  error,
});

export const Some = <T>(value: T): Option<T> => ({
  kind: "some",
  value,
});

export const None: Option<never> = { kind: "none" };

// ─── Effect Tracking (from Haskell, approximated) ───

/**
 * Branded type to track effects at the type level.
 * A value of type IO<T> signals that producing T requires side effects.
 */
export type IO<T> = T & { readonly __brand: "IO" };

/**
 * Branded type for federated computation.
 * Signals that this computation runs across distributed nodes
 * and raw data never leaves the local node.
 */
export type Federated<T> = T & { readonly __brand: "Federated" };

/**
 * Wrap a value as an IO effect.
 */
export function io<T>(value: T): IO<T> {
  return value as IO<T>;
}

/**
 * Wrap a value as a federated computation result.
 */
export function federated<T>(value: T): Federated<T> {
  return value as Federated<T>;
}

// ─── Pipe (from R / OCaml) ───

/**
 * Pipe a value through a sequence of functions.
 * Emulates Neu's |> operator.
 */
export function pipe<A>(value: A): PipeChain<A> {
  return new PipeChain(value);
}

export class PipeChain<T> {
  constructor(private readonly value: T) {}

  then<U>(fn: (value: T) => U): PipeChain<U> {
    return new PipeChain(fn(this.value));
  }

  async thenAsync<U>(fn: (value: T) => Promise<U>): Promise<PipeChain<U>> {
    const result = await fn(this.value);
    return new PipeChain(result);
  }

  unwrap(): T {
    return this.value;
  }
}

// ─── DataFrame (from R) ───

/**
 * Minimal typed DataFrame — tabular data as a primitive.
 * Each column is a typed array, and the schema is known at compile time.
 */
export type DataFrame<T extends Record<string, unknown>> = {
  readonly columns: { [K in keyof T]: T[K][] };
  readonly length: number;
};

export function dataframe<T extends Record<string, unknown>>(columns: {
  [K in keyof T]: T[K][];
}): DataFrame<T> {
  const lengths = Object.values(columns).map(
    (col) => (col as unknown[]).length,
  );
  const length = lengths[0] ?? 0;
  if (!lengths.every((l) => l === length)) {
    throw new Error("All columns must have the same length");
  }
  return { columns, length };
}

export function dfFilter<T extends Record<string, unknown>>(
  df: DataFrame<T>,
  predicate: (row: T, index: number) => boolean,
): DataFrame<T> {
  const keys = Object.keys(df.columns) as (keyof T)[];
  const result = Object.fromEntries(keys.map((k) => [k, [] as unknown[]])) as {
    [K in keyof T]: T[K][];
  };

  for (let i = 0; i < df.length; i++) {
    const row = Object.fromEntries(keys.map((k) => [k, df.columns[k][i]])) as T;
    if (predicate(row, i)) {
      for (const k of keys) {
        (result[k] as unknown[]).push(df.columns[k][i]);
      }
    }
  }

  return dataframe(result);
}

export function dfSelect<T extends Record<string, unknown>, K extends keyof T>(
  df: DataFrame<T>,
  ...keys: K[]
): DataFrame<Pick<T, K>> {
  const result = Object.fromEntries(keys.map((k) => [k, df.columns[k]])) as {
    [P in K]: T[P][];
  };
  return { columns: result, length: df.length } as DataFrame<Pick<T, K>>;
}

export function dfMutate<
  T extends Record<string, unknown>,
  U extends Record<string, unknown>,
>(
  df: DataFrame<T>,
  mutations: { [K in keyof U]: (row: T, index: number) => U[K] },
): DataFrame<T & U> {
  const keys = Object.keys(df.columns) as (keyof T)[];
  const mutationKeys = Object.keys(mutations) as (keyof U)[];

  const existingColumns = Object.fromEntries(
    keys.map((k) => [k, [...df.columns[k]]]),
  );

  const newColumns = Object.fromEntries(
    mutationKeys.map((mk) => {
      const fn = mutations[mk];
      const col: unknown[] = [];
      for (let i = 0; i < df.length; i++) {
        const row = Object.fromEntries(
          keys.map((k) => [k, df.columns[k][i]]),
        ) as T;
        col.push(fn(row, i));
      }
      return [mk, col];
    }),
  );

  return dataframe({ ...existingColumns, ...newColumns } as {
    [K in keyof (T & U)]: (T & U)[K][];
  });
}
