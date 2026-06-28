# beUI Component Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate the project's components (QuestionCard, ChoiceCard, FillCard, QuizFooter, AdminSidebar, AdminQuestionEditor, AdminPage) to beUI bespoke motion components to elevate UI aesthetics and interactivity.

**Architecture:** Integrate beUI motion components (Tilt Card, Button, Tabs, Radio) into the project's folder hierarchy under `@/components/motion`, then refactor existing components and pages to consume these motion components.

**Tech Stack:** Next.js (App Router), React 19, Motion (Framer Motion v12), Tailwind CSS v4, Lucide React.

## Global Constraints

- Use `@/*` import alias to access root folders (e.g. `@/components/motion/button`, `@/lib/ease`).
- Ensure all React components use `"use client"` where state or hooks are utilized.
- All styles should integrate harmoniously with Tailwind CSS v4 styling rules set in `@/app/globals.css`.

---

### Task 1: Create use-hover-capable Hook
**Files:**
- Create: `lib/hooks/use-hover-capable.ts`

**Interfaces:**
- Produces: `useHoverCapable: () => boolean`

- [ ] **Step 1: Create use-hover-capable hook file**
  Create [use-hover-capable.ts](file:///d:/workSpace/Code/Project/quizly/lib/hooks/use-hover-capable.ts) with the following content:
  ```typescript
  "use client";

  import { useEffect, useState } from "react";

  /**
   * Returns true only on devices that have a true hover (mouse / trackpad).
   * Touch devices fire phantom `:hover` on tap that sticks until tap-elsewhere
   * — gate hover-only effects (scale lifts, magnetic pulls) behind this.
   */
  export function useHoverCapable() {
    const [canHover, setCanHover] = useState(false);

    useEffect(() => {
      if (typeof window === "undefined" || !window.matchMedia) return;
      const mq = window.matchMedia("(hover: hover) and (pointer: fine)");
      const update = () => setCanHover(mq.matches);
      update();
      mq.addEventListener?.("change", update);
      return () => mq.removeEventListener?.("change", update);
    }, []);

    return canHover;
  }
  ```

- [ ] **Step 2: Verify compilation**
  Run: `bun run build`
  Expected: Successful compilation, no syntax errors.

- [ ] **Step 3: Commit**
  ```bash
  git add lib/hooks/use-hover-capable.ts
  git commit -m "feat: add useHoverCapable hook"
  ```

---

### Task 2: Create TiltCard Component
**Files:**
- Create: `components/motion/tilt-card.tsx`

**Interfaces:**
- Consumes: `useHoverCapable` from `@/lib/hooks/use-hover-capable`
- Produces: `TiltCard: (props: TiltCardProps) => ReactNode`

- [ ] **Step 1: Create tilt-card.tsx**
  Create [tilt-card.tsx](file:///d:/workSpace/Code/Project/quizly/components/motion/tilt-card.tsx) with the following content:
  ```tsx
  "use client";

  import { motion, useMotionTemplate, useMotionValue, useReducedMotion, useSpring } from "motion/react";
  import { useRef, type ReactNode } from "react";
  import { SPRING_MOUSE } from "@/lib/ease";
  import { useHoverCapable } from "@/lib/hooks/use-hover-capable";
  import { cn } from "@/lib/utils";

  export interface TiltCardProps {
    children: ReactNode;
    max?: number;
    glare?: boolean;
    className?: string;
  }

  export function TiltCard({ children, max = 12, glare = true, className }: TiltCardProps) {
    const ref = useRef<HTMLDivElement>(null);
    const reduce = useReducedMotion();
    const canHover = useHoverCapable();
    // Decorative cursor-follow: skip on touch (phantom hover) and reduced motion.
    const enabled = !reduce && canHover;
    const rx = useMotionValue(0);
    const ry = useMotionValue(0);
    const gx = useMotionValue(50);
    const gy = useMotionValue(50);

    const srx = useSpring(rx, SPRING_MOUSE);
    const sry = useSpring(ry, SPRING_MOUSE);

    const onMove = (e: React.MouseEvent<HTMLDivElement>) => {
      const el = ref.current;
      if (!el || !enabled) return;
      const rect = el.getBoundingClientRect();
      const px = (e.clientX - rect.left) / rect.width;
      const py = (e.clientY - rect.top) / rect.height;
      ry.set((px - 0.5) * max);
      rx.set((0.5 - py) * max);
      gx.set(px * 100);
      gy.set(py * 100);
    };

    const onLeave = () => {
      rx.set(0);
      ry.set(0);
    };

    const transform = useMotionTemplate`perspective(1000px) rotateX(${srx}deg) rotateY(${sry}deg)`;
    const glareBg = useMotionTemplate`radial-gradient(circle at ${gx}% ${gy}%, var(--foreground), transparent 50%)`;

    return (
      <motion.div
        ref={ref}
        onMouseMove={onMove}
        onMouseLeave={onLeave}
        style={{ transform, transformStyle: "preserve-3d" }}
        className={cn("relative overflow-hidden rounded-2xl will-change-transform", className)}
      >
        {children}
        {glare && enabled ? (
          <motion.div
            aria-hidden
            style={{ background: glareBg }}
            className="pointer-events-none absolute inset-0 opacity-15"
          />
        ) : null}
      </motion.div>
    );
  }
  ```

- [ ] **Step 2: Verify compilation**
  Run: `bun run build`
  Expected: Successful compilation, no syntax errors.

- [ ] **Step 3: Commit**
  ```bash
  git add components/motion/tilt-card.tsx
  git commit -m "feat: add TiltCard component"
  ```

---

### Task 3: Create Magnetic Wrapper & Button Component Group
**Files:**
- Create: `components/motion/magnetic.tsx`
- Create: `components/motion/button/base.tsx`
- Create: `components/motion/button/stateful.tsx`
- Create: `components/motion/button/magnetic.tsx`
- Create: `components/motion/button/index.tsx`

**Interfaces:**
- Consumes: `useHoverCapable` from `@/lib/hooks/use-hover-capable`
- Produces: 
  * `Magnetic: (props: MagneticProps) => ReactNode`
  * `Button: (props: ButtonProps) => ReactNode`
  * `StatefulButton: (props: StatefulButtonProps) => ReactNode`
  * `MagneticButton: (props: MagneticButtonProps) => ReactNode`

- [ ] **Step 1: Create magnetic.tsx wrapper**
  Create [magnetic.tsx](file:///d:/workSpace/Code/Project/quizly/components/motion/magnetic.tsx) with the following content:
  ```tsx
  "use client";

  import { motion, useMotionValue, useReducedMotion, useSpring } from "motion/react";
  import { useRef, type ReactNode } from "react";
  import { SPRING_MOUSE } from "@/lib/ease";
  import { useHoverCapable } from "@/lib/hooks/use-hover-capable";
  import { cn } from "@/lib/utils";

  export interface MagneticProps {
    children: ReactNode;
    strength?: number;
    className?: string;
  }

  export function Magnetic({ children, strength = 0.35, className }: MagneticProps) {
    const ref = useRef<HTMLDivElement>(null);
    const reduce = useReducedMotion();
    const canHover = useHoverCapable();
    // Decorative cursor-follow: skip on touch (phantom hover) and reduced motion.
    const enabled = !reduce && canHover;
    const x = useMotionValue(0);
    const y = useMotionValue(0);
    const sx = useSpring(x, SPRING_MOUSE);
    const sy = useSpring(y, SPRING_MOUSE);

    const onMove = (e: React.MouseEvent<HTMLDivElement>) => {
      const el = ref.current;
      if (!el || !enabled) return;
      const rect = el.getBoundingClientRect();
      x.set((e.clientX - rect.left - rect.width / 2) * strength);
      y.set((e.clientY - rect.top - rect.height / 2) * strength);
    };

    const onLeave = () => {
      x.set(0);
      y.set(0);
    };

    return (
      <motion.div
        ref={ref}
        onMouseMove={onMove}
        onMouseLeave={onLeave}
        style={{ x: sx, y: sy }}
        className={cn("inline-block", className)}
      >
        {children}
      </motion.div>
    );
  }
  ```

- [ ] **Step 2: Create button/base.tsx**
  Create [base.tsx](file:///d:/workSpace/Code/Project/quizly/components/motion/button/base.tsx) with the following content:
  ```tsx
  "use client";

  import {
    AnimatePresence,
    motion,
    useReducedMotion,
    type HTMLMotionProps,
  } from "motion/react";
  import {
    forwardRef,
    type PointerEvent,
    type ReactNode,
    useCallback,
    useRef,
    useState,
  } from "react";
  import { EASE_OUT, SPRING_PRESS } from "@/lib/ease";
  import { cn } from "@/lib/utils";
  import { useHoverCapable } from "@/lib/hooks/use-hover-capable";

  export type ButtonVariant = "primary" | "secondary" | "ghost" | "outline";
  export type ButtonSize = "sm" | "md" | "lg" | "icon";

  export interface ButtonProps extends Omit<
    HTMLMotionProps<"button">,
    "children"
  > {
    variant?: ButtonVariant;
    size?: ButtonSize;
    pressScale?: number;
    ripple?: boolean;
    children?: ReactNode;
  }

  type Ripple = { id: number; x: number; y: number; size: number };

  const VARIANT_CLASS: Record<ButtonVariant, string> = {
    primary: "bg-teal-600 text-white hover:bg-teal-700",
    secondary: "border border-slate-200 bg-white text-slate-700 hover:bg-slate-50",
    ghost: "text-slate-600 hover:text-slate-900 hover:bg-slate-50",
    outline: "border border-slate-200 bg-transparent text-slate-700 hover:bg-slate-50",
  };

  const SIZE_CLASS: Record<ButtonSize, string> = {
    sm: "h-8 px-3 text-xs gap-1.5 rounded-full",
    md: "h-10 px-5 text-sm gap-2 rounded-full",
    lg: "h-12 px-6 text-base gap-2 rounded-full",
    icon: "h-8 w-8 rounded-lg",
  };

  export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
    function Button(
      {
        variant = "primary",
        size = "md",
        pressScale = 0.93,
        ripple = false,
        className,
        children,
        onPointerDown,
        ...rest
      },
      ref,
    ) {
      const reduce = useReducedMotion();
      const canHover = useHoverCapable();
      const [ripples, setRipples] = useState<Ripple[]>([]);
      const nextId = useRef(0);

      const handlePointerDown = useCallback(
        (event: PointerEvent<HTMLButtonElement>) => {
          if (ripple && !reduce) {
            const rect = event.currentTarget.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height) * 2;
            setRipples((prev) => [
              ...prev,
              {
                id: nextId.current++,
                x: event.clientX - rect.left,
                y: event.clientY - rect.top,
                size,
              },
            ]);
          }
          onPointerDown?.(event);
        },
        [ripple, reduce, onPointerDown],
      );

      return (
        <motion.button
          ref={ref}
          type="button"
          whileTap={reduce ? undefined : { scale: pressScale }}
          whileHover={reduce || !canHover ? undefined : { scale: 1.02 }}
          transition={SPRING_PRESS}
          onPointerDown={handlePointerDown}
          className={cn(
            "inline-flex items-center justify-center font-semibold select-none",
            "transition-colors duration-200 cursor-pointer",
            "disabled:pointer-events-none disabled:opacity-50",
            ripple && "relative overflow-hidden",
            VARIANT_CLASS[variant],
            SIZE_CLASS[size],
            className,
          )}
          {...rest}
        >
          {ripple && !reduce ? (
            <span className="pointer-events-none absolute inset-0 overflow-hidden rounded-[inherit]">
              <AnimatePresence>
                {ripples.map((r) => (
                  <motion.span
                    key={r.id}
                    className="absolute rounded-full bg-current"
                    style={{
                      left: r.x,
                      top: r.y,
                      width: r.size,
                      height: r.size,
                      x: "-50%",
                      y: "-50%",
                    }}
                    initial={{ scale: 0, opacity: 0.3 }}
                    animate={{ scale: 1, opacity: 0 }}
                    exit={{ opacity: 0 }}
                    transition={{ duration: 1.6, ease: EASE_OUT }}
                    onAnimationComplete={() =>
                      setRipples((prev) => prev.filter((x) => x.id !== r.id))
                    }
                  />
                ))}
              </AnimatePresence>
            </span>
          ) : null}
          {children}
        </motion.button>
      );
    },
  );
  ```

- [ ] **Step 3: Create button/stateful.tsx**
  Create [stateful.tsx](file:///d:/workSpace/Code/Project/quizly/components/motion/button/stateful.tsx) with the following content:
  ```tsx
  "use client";

  import {
    AnimatePresence,
    motion,
    useReducedMotion,
    type Variants,
  } from "motion/react";
  import { Check, Loader2, X } from "lucide-react";
  import {
    forwardRef,
    useLayoutEffect,
    useRef,
    useState,
    type ReactNode,
  } from "react";
  import { EASE_OUT, SPRING_SWAP } from "@/lib/ease";
  import { Button, type ButtonProps } from "./base";

  export type ButtonState = "idle" | "loading" | "success" | "error";

  export interface StatefulButtonProps extends Omit<ButtonProps, "children"> {
    state?: ButtonState;
    children: ReactNode;
    loadingText?: ReactNode;
    successText?: ReactNode;
    errorText?: ReactNode;
    icon?: ReactNode;
  }

  const CASCADE_STAGGER = 0.025;
  const ROLL_BLUR = "blur(6px)";

  const CASCADE_LETTER_VARIANTS: Variants = {
    initial: { opacity: 0, y: "105%", filter: ROLL_BLUR },
    animate: (delay: number = 0) => ({
      opacity: 1,
      y: "0%",
      filter: "blur(0px)",
      transition: { ...SPRING_SWAP, delay },
    }),
    exit: (delay: number = 0) => ({
      opacity: 0,
      y: "-105%",
      filter: ROLL_BLUR,
      transition: { duration: 0.16, ease: EASE_OUT, delay: delay * 0.5 },
    }),
  };

  const ICON_VARIANTS: Variants = {
    initial: { opacity: 0, width: 0, scale: 0.7, filter: ROLL_BLUR },
    animate: {
      opacity: 1,
      width: "1.25rem",
      scale: 1,
      filter: "blur(0px)",
      transition: SPRING_SWAP,
    },
    exit: {
      opacity: 0,
      width: 0,
      scale: 0.7,
      filter: ROLL_BLUR,
      transition: { duration: 0.16, ease: EASE_OUT },
    },
  };

  function IconSlot({ keyId, children }: { keyId: string; children: ReactNode }) {
    const reduce = useReducedMotion();
    return (
      <motion.span
        key={keyId}
        variants={ICON_VARIANTS}
        initial={reduce ? { opacity: 0 } : "initial"}
        animate={reduce ? { opacity: 1 } : "animate"}
        exit={reduce ? { opacity: 0 } : "exit"}
        transition={reduce ? { duration: 0.15 } : undefined}
        className="inline-grid shrink-0 place-items-center overflow-hidden mr-1.5"
      >
        {children}
      </motion.span>
    );
  }

  function TextSlot({
    value,
    children,
  }: {
    value: string;
    children: ReactNode;
  }) {
    const reduce = useReducedMotion();
    const measureRef = useRef<HTMLSpanElement>(null);
    const [width, setWidth] = useState<number>();
    const label = typeof children === "string" ? children : null;
    const cascade = label !== null && !reduce;

    useLayoutEffect(() => {
      const nextWidth = measureRef.current?.offsetWidth;
      if (!nextWidth) return;
      setWidth((current) => (current === nextWidth ? current : nextWidth));
    });

    return (
      <motion.span
        initial={false}
        animate={{ width }}
        transition={reduce ? { duration: 0 } : SPRING_SWAP}
        className="relative inline-block overflow-hidden whitespace-nowrap align-bottom"
      >
        <span
          ref={measureRef}
          aria-hidden
          className="invisible inline-block whitespace-nowrap"
        >
          {children}
        </span>

        {cascade ? (
          <>
            <span className="sr-only">{label}</span>
            <AnimatePresence initial={false}>
              <motion.span
                key={`cascade-${value}`}
                aria-hidden
                initial="initial"
                animate="animate"
                exit="exit"
                className="absolute left-0 top-0 inline-block whitespace-pre"
              >
                {label.split("").map((char, index) => (
                  <motion.span
                    key={index}
                    custom={index * CASCADE_STAGGER}
                    variants={CASCADE_LETTER_VARIANTS}
                    className="inline-block whitespace-pre will-change-[opacity,filter,transform]"
                  >
                    {char}
                  </motion.span>
                ))}
              </motion.span>
            </AnimatePresence>
          </>
        ) : (
          <AnimatePresence initial={false}>
            <motion.span
              key={`text-${value}`}
              initial={reduce ? { opacity: 0 } : { opacity: 0, y: 14, filter: ROLL_BLUR }}
              animate={reduce ? { opacity: 1 } : { opacity: 1, y: 0, filter: "blur(0px)" }}
              exit={reduce ? { opacity: 0 } : { opacity: 0, y: -14, filter: ROLL_BLUR }}
              transition={reduce ? { duration: 0.15 } : SPRING_SWAP}
              className="absolute left-0 top-0 inline-block will-change-[opacity,filter,transform]"
            >
              {children}
            </motion.span>
          </AnimatePresence>
        )}
      </motion.span>
    );
  }

  export const StatefulButton = forwardRef<HTMLButtonElement, StatefulButtonProps>(function StatefulButton(
    {
      state = "idle",
      children,
      loadingText = "加载中",
      successText = "提交成功",
      errorText = "重试",
      icon,
      disabled,
      ...rest
    },
    ref,
  ) {
    const isBusy = state === "loading";
    const stateText =
      state === "loading"
        ? loadingText
        : state === "success"
          ? successText
          : state === "error"
          ? errorText
          : children;
    const textKey =
      typeof stateText === "string" ? `${state}-${stateText}` : state;

    return (
      <Button ref={ref} disabled={disabled || isBusy} aria-busy={isBusy} whileHover={undefined} {...rest}>\n        <span
          aria-live="polite"
          className="relative inline-flex items-center justify-center overflow-hidden"
        >
          <AnimatePresence initial={false}>
            {state === "loading" ? (
              <IconSlot keyId="loading-icon">
                <Loader2 className="h-4 w-4 animate-spin" />
              </IconSlot>
            ) : null}
            {state === "success" ? (
              <IconSlot keyId="success-icon">
                <Check className="h-4 w-4" />
              </IconSlot>
            ) : null}
            {state === "error" ? (
              <IconSlot keyId="error-icon">
                <X className="h-4 w-4" />
              </IconSlot>
            ) : null}
          </AnimatePresence>

          <TextSlot value={textKey}>{stateText}</TextSlot>

          <AnimatePresence initial={false}>
            {state === "idle" && icon ? (
              <IconSlot keyId="idle-icon">{icon}</IconSlot>
            ) : null}
          </AnimatePresence>
        </span>
      </Button>
    );
  });
  ```

- [ ] **Step 4: Create button/magnetic.tsx**
  Create [magnetic.tsx](file:///d:/workSpace/Code/Project/quizly/components/motion/button/magnetic.tsx) with the following content:
  ```tsx
  "use client";

  import { forwardRef } from "react";
  import { Magnetic } from "../magnetic";
  import { Button, type ButtonProps } from "./base";

  export interface MagneticButtonProps extends ButtonProps {
    strength?: number;
    magneticClassName?: string;
  }

  export const MagneticButton = forwardRef<HTMLButtonElement, MagneticButtonProps>(function MagneticButton(
    { strength = 0.25, magneticClassName, children, ...rest },
    ref,
  ) {
    return (
      <Magnetic strength={strength} className={magneticClassName}>
        <Button ref={ref} {...rest}>
          {children}
        </Button>
      </Magnetic>
    );
  });
  ```

- [ ] **Step 5: Create button/index.tsx**
  Create [index.tsx](file:///d:/workSpace/Code/Project/quizly/components/motion/button/index.tsx) with the following content:
  ```tsx
  export { Button } from "./base";
  export type { ButtonProps, ButtonVariant, ButtonSize } from "./base";

  export { StatefulButton } from "./stateful";
  export type { StatefulButtonProps, ButtonState } from "./stateful";

  export { MagneticButton } from "./magnetic";
  export type { MagneticButtonProps } from "./magnetic";
  ```

- [ ] **Step 6: Verify compilation**
  Run: `bun run build`
  Expected: Successful compilation, no syntax errors.

- [ ] **Step 7: Commit**
  ```bash
  git add components/motion/magnetic.tsx components/motion/button
  git commit -m "feat: add Magnetic wrapper and Button component variants"
  ```

---

### Task 4: Create Tabs Component
**Files:**
- Create: `components/motion/tabs.tsx`

**Interfaces:**
- Produces: 
  * `Tabs`, `TabsList`, `TabsTrigger`, `TabsContent`

- [ ] **Step 1: Create tabs.tsx**
  Create [tabs.tsx](file:///d:/workSpace/Code/Project/quizly/components/motion/tabs.tsx) with the following content:
  ```tsx
  "use client";

  import { motion, MotionConfig, useReducedMotion, type Transition } from "motion/react";
  import { createContext, useContext, useId, useState, type ReactNode } from "react";
  import { EASE_OUT } from "@/lib/ease";
  import { cn } from "@/lib/utils";

  type Variant = "pill" | "underline" | "segment";

  type Ctx = {
    value: string;
    setValue: (v: string) => void;
    layoutId: string;
    variant: Variant;
  };

  const TabsCtx = createContext<Ctx | null>(null);

  function useTabs() {
    const ctx = useContext(TabsCtx);
    if (!ctx) throw new Error("Tabs.* must be used inside <Tabs>");
    return ctx;
  }

  const transition: Transition = {
    type: "spring",
    stiffness: 170,
    damping: 24,
    mass: 1.2,
  };

  export function Tabs({
    defaultValue,
    value,
    onValueChange,
    variant = "pill",
    children,
    className,
  }: {
    defaultValue?: string;
    value?: string;
    onValueChange?: (v: string) => void;
    variant?: Variant;
    children: ReactNode;
    className?: string;
  }) {
    const [internal, setInternal] = useState(defaultValue ?? "");
    const layoutId = useId();
    const reduce = useReducedMotion();
    const controlled = value !== undefined;
    const current = controlled ? value : internal;
    const setValue = (v: string) => {
      if (!controlled) setInternal(v);
      onValueChange?.(v);
    };
    return (
      <MotionConfig transition={reduce ? { duration: 0 } : transition}>
        <TabsCtx.Provider value={{ value: current, setValue, layoutId, variant }}>
          <motion.div layoutRoot className={className}>
            {children}
          </motion.div>
        </TabsCtx.Provider>
      </MotionConfig>
    );
  }

  const listClasses: Record<Variant, string> = {
    pill: "inline-flex items-center gap-1 rounded-full bg-slate-100 p-1 border border-slate-200/50",
    underline: "inline-flex items-center gap-1 border-b border-slate-200",
    segment: "inline-flex items-center gap-0 rounded-lg bg-slate-100 p-0.5 border border-slate-200/50",
  };

  export function TabsList({ children, className }: { children: ReactNode; className?: string }) {
    const { variant } = useTabs();
    return (
      <div role="tablist" className={cn(listClasses[variant], className)}>
        {children}
      </div>
    );
  }

  export function TabsTrigger({
    value,
    children,
    className,
    indicatorClassName,
  }: {
    value: string;
    children: ReactNode;
    className?: string;
    indicatorClassName?: string;
  }) {
    const { value: current, setValue, layoutId, variant } = useTabs();
    const active = current === value;

    if (variant === "underline") {
      return (
        <button
          type="button"
          role="tab"
          aria-selected={active}
          onClick={() => setValue(value)}
          className={cn(
            "relative isolate px-3 pb-2.5 pt-1 -mb-px text-sm font-semibold transition-colors min-h-[40px] inline-flex items-center cursor-pointer",
            active ? "text-teal-600" : "text-slate-500 hover:text-slate-800",
            className,
          )}
        >
          {children}
          {active ? (
          <motion.span
            layoutId={layoutId}
            className={cn(
              "absolute -bottom-px left-0 right-0 h-[2px] bg-teal-600",
              indicatorClassName,
            )}
          />
          ) : null}
        </button>
      );
    }

    const radius = variant === "pill" ? "rounded-full" : "rounded-md";

    return (
      <div className="relative cursor-pointer">
        {active ? (
          <motion.span
            layoutId={layoutId}
            style={{ borderRadius: variant === "pill" ? 9999 : 6 }}
            className={cn(
              "absolute inset-0 bg-white shadow-sm border border-slate-200/20",
              radius,
              indicatorClassName,
            )}
          />
        ) : null}
        <button
          type="button"
          role="tab"
          aria-selected={active}
          onClick={() => setValue(value)}
          className={cn(
            "relative z-10 inline-flex items-center justify-center whitespace-nowrap bg-transparent px-3.5 py-1.5 text-sm font-semibold transition-colors outline-none cursor-pointer",
            active ? "text-teal-600" : "text-slate-500 hover:text-slate-800",
            radius,
            className,
          )}
        >
          {children}
        </button>
      </div>
    );
  }

  export function TabsContent({ value, children, className }: { value: string; children: ReactNode; className?: string }) {
    const { value: current } = useTabs();
    const reduce = useReducedMotion();
    const active = current === value;
    if (!active) {
      return (
        <div hidden className={className}>
          {children}
        </div>
      );
    }
    return (
      <motion.div
        key={value}
        initial={{ opacity: 0, y: reduce ? 0 : 4 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.18, ease: EASE_OUT }}
        className={cn("mt-4", className)}
      >
        {children}
      </motion.div>
    );
  }
  ```

- [ ] **Step 2: Verify compilation**
  Run: `bun run build`
  Expected: Successful compilation, no syntax errors.

- [ ] **Step 3: Commit**
  ```bash
  git add components/motion/tabs.tsx
  git commit -m "feat: add Tabs component"
  ```

---

### Task 5: Create Radio Component
**Files:**
- Create: `components/motion/radio.tsx`

**Interfaces:**
- Produces:
  * `RadioGroup`, `RadioGroupItem`

- [ ] **Step 1: Create radio.tsx**
  Create [radio.tsx](file:///d:/workSpace/Code/Project/quizly/components/motion/radio.tsx) with the following content:
  ```tsx
  "use client";

  import { motion, MotionConfig, useReducedMotion } from "motion/react";
  import {
    createContext,
    useContext,
    useId,
    useState,
    type ReactNode,
  } from "react";
  import { SPRING_LAYOUT, SPRING_PRESS } from "@/lib/ease";
  import { cn } from "@/lib/utils";

  type RadioCtx = {
    value: string;
    setValue: (value: string) => void;
    layoutId: string;
  };

  const RadioCtx = createContext<RadioCtx | null>(null);

  function useRadioGroup() {
    const ctx = useContext(RadioCtx);
    if (!ctx) {
      throw new Error("RadioGroupItem must be used inside <RadioGroup>");
    }
    return ctx;
  }

  export interface RadioGroupProps {
    value?: string;
    defaultValue?: string;
    onValueChange?: (value: string) => void;
    children: ReactNode;
    className?: string;
    orientation?: "vertical" | "horizontal";
  }

  export function RadioGroup({
    value,
    defaultValue = "",
    onValueChange,
    children,
    className,
    orientation = "vertical",
  }: RadioGroupProps) {
    const [internal, setInternal] = useState(defaultValue);
    const layoutId = useId();
    const reduce = useReducedMotion();
    const controlled = value !== undefined;
    const current = controlled ? value : internal;
    const setValue = (next: string) => {
      if (!controlled) setInternal(next);
      onValueChange?.(next);
    };

    return (
      <MotionConfig transition={reduce ? { duration: 0 } : SPRING_LAYOUT}>
        <RadioCtx.Provider value={{ value: current, setValue, layoutId }}>
          <div
            role="radiogroup"
            className={cn(
              "flex gap-3",
              orientation === "vertical" ? "flex-col" : "flex-row flex-wrap",
              className,
            )}
          >
            {children}
          </div>
        </RadioCtx.Provider>
      </MotionConfig>
    );
  }

  export interface RadioGroupItemProps {
    value: string;
    label?: string;
    disabled?: boolean;
    className?: string;
    id?: string;
  }

  export function RadioGroupItem({
    value,
    label,
    disabled,
    className,
    id: idProp,
  }: RadioGroupItemProps) {
    const { value: groupValue, setValue, layoutId } = useRadioGroup();
    const autoId = useId();
    const id = idProp ?? autoId;
    const reduce = useReducedMotion();
    const selected = groupValue === value;

    return (
      <label
        htmlFor={id}
        className={cn(
          "inline-flex items-center gap-3",
          disabled ? "cursor-not-allowed" : "cursor-pointer",
          className,
        )}
      >
        <motion.button
          id={id}
          type="button"
          role="radio"
          aria-checked={selected}
          disabled={disabled}
          onClick={() => !disabled && setValue(value)}
          whileTap={reduce || disabled ? undefined : { scale: 0.92 }}
          transition={SPRING_PRESS}
          data-state={selected ? "checked" : "unchecked"}
          className={cn(
            "relative inline-flex h-5 w-5 shrink-0 items-center justify-center rounded-full border-2 outline-none transition-colors duration-200 cursor-pointer",
            "focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background",
            "disabled:cursor-not-allowed disabled:opacity-60",
            selected
              ? "border-teal-600 bg-teal-50"
              : "border-slate-300 hover:border-slate-400 bg-white",
          )}
        >
          {selected ? (
            <motion.span
              layoutId={layoutId}
              className="absolute inset-1 rounded-full bg-teal-600"
              transition={reduce ? { duration: 0 } : SPRING_LAYOUT}
            />
          ) : null}
        </motion.button>
        {label ? (
          <span className={cn("select-none text-sm text-slate-700", disabled && "opacity-60")}>
            {label}
          </span>
        ) : null}
      </label>
    );
  }
  ```

- [ ] **Step 2: Verify compilation**
  Run: `bun run build`
  Expected: Successful compilation, no syntax errors.

- [ ] **Step 3: Commit**
  ```bash
  git add components/motion/radio.tsx
  git commit -m "feat: add Radio component"
  ```

---

### Task 6: Refactor QuestionCard to use TiltCard
**Files:**
- Modify: `components/QuestionCard.tsx`

**Interfaces:**
- Consumes: `TiltCard` from `@/components/motion/tilt-card`

- [ ] **Step 1: Modify QuestionCard.tsx**
  Edit [QuestionCard.tsx](file:///d:/workSpace/Code/Project/quizly/components/QuestionCard.tsx) to wrap the outer `div` inside `<TiltCard max={4} glare={true} className="...">`:
  ```diff
  --- d:/workSpace/Code/Project/quizly/components/QuestionCard.tsx
  +++ d:/workSpace/Code/Project/quizly/components/QuestionCard.tsx
  @@ -6,2 +6,3 @@
   import FeedbackBanner from "./FeedbackBanner";
  +import { TiltCard } from "./motion/tilt-card";
   
  @@ -82,5 +83,5 @@
     return (
  -    <div
  -      className={`bg-white border border-slate-200 rounded-xl p-6 mb-4 shadow-sm transition-shadow duration-300 ${cardBorder}`}
  -    >
  +    <TiltCard
  +      max={4}
  +      glare={true}
  +      className={`bg-white border border-slate-200 rounded-xl p-6 mb-4 shadow-sm transition-all duration-300 ${cardBorder}`}
  +    >
         {/* Question header */}
  @@ -119,3 +120,3 @@
  -    </div>
  +    </TiltCard>
     );
   }
  ```

- [ ] **Step 2: Verify compilation**
  Run: `bun run build`
  Expected: Successful compilation, no syntax errors.

- [ ] **Step 3: Commit**
  ```bash
  git add components/QuestionCard.tsx
  git commit -m "refactor: wrap QuestionCard with beUI TiltCard"
  ```

---

### Task 7: Refactor ChoiceCard to use RadioGroup
**Files:**
- Modify: `components/ChoiceCard.tsx`

**Interfaces:**
- Consumes: `RadioGroup`, `RadioGroupItem` from `@/components/motion/radio`

- [ ] **Step 1: Modify ChoiceCard.tsx**
  Edit [ChoiceCard.tsx](file:///d:/workSpace/Code/Project/quizly/components/ChoiceCard.tsx) to replace the choices container with `RadioGroup` and each item with a card that utilizes `RadioGroupItem`:
  ```tsx
  "use client";

  import type { Question, FillQuestion } from "@/lib/types";
  import { RadioGroup, RadioGroupItem } from "./motion/radio";

  interface ChoiceCardProps {
    question: Exclude<Question, FillQuestion>;
    index: number;
    done: boolean;
    selectedIdx?: number;
    onPick: (qi: number, oi: number) => void;
  }

  export default function ChoiceCard({
    question,
    index,
    done,
    selectedIdx,
    onPick,
  }: ChoiceCardProps) {
    const opts = (question as any).shuffledOptions || question.options;
    const correctIdx = (question as any).correctShuffledIdx;

    return (
      <RadioGroup
        value={selectedIdx !== undefined ? String(selectedIdx) : undefined}
        onValueChange={(val) => !done && onPick(index, Number(val))}
        className="pl-0 gap-1.5"
      >
        {opts.map((opt: { label: string; text: string }, oi: number) => {
          let optCls = "flex items-center gap-3 p-3 my-[2px] border border-slate-200 rounded-xl cursor-pointer select-none bg-white transition-all duration-200 hover:border-slate-300";

          if (done) {
            optCls += " cursor-default pointer-events-none";
            if (oi === correctIdx) {
              optCls += " border-green-300 bg-green-50 ring-1 ring-green-300";
            } else if (oi === selectedIdx && oi !== correctIdx) {
              optCls += " border-red-300 bg-red-50 ring-1 ring-red-300";
            }
          } else {
            if (oi === selectedIdx) {
              optCls += " border-teal-600 ring-1 ring-teal-600";
            }
          }

          return (
            <div
              key={oi}
              className={optCls}
              onClick={() => !done && onPick(index, oi)}
            >
              <RadioGroupItem
                value={String(oi)}
                disabled={done}
                className="pointer-events-none"
              />
              <span className="text-[14.5px] text-slate-900 leading-relaxed">
                <span className="opt-key font-bold mr-1">{opt.label}.</span>
                {opt.text}
              </span>
            </div>
          );
        })}
      </RadioGroup>
    );
  }
  ```

- [ ] **Step 2: Verify compilation**
  Run: `bun run build`
  Expected: Successful compilation, no syntax errors.

- [ ] **Step 3: Commit**
  ```bash
  git add components/ChoiceCard.tsx
  git commit -m "refactor: use RadioGroup in ChoiceCard"
  ```

---

### Task 8: Refactor FillCard to use beUI Button
**Files:**
- Modify: `components/FillCard.tsx`

**Interfaces:**
- Consumes: `Button` from `@/components/motion/button`

- [ ] **Step 1: Modify FillCard.tsx**
  Edit [FillCard.tsx](file:///d:/workSpace/Code/Project/quizly/components/FillCard.tsx) to replace the normal HTML submit button with the spring-press beUI `Button`:
  ```diff
  --- d:/workSpace/Code/Project/quizly/components/FillCard.tsx
  +++ d:/workSpace/Code/Project/quizly/components/FillCard.tsx
  @@ -4,2 +4,3 @@
   import type { FillQuestion } from "@/lib/types";
   import { useState } from "react";
  +import { Button } from "./motion/button";
   
  @@ -67,6 +68,7 @@
         {!done && (
  -        <button
  -          className="self-end px-7 py-2 rounded-full text-sm font-semibold font-sans text-white border-none bg-teal-600 cursor-pointer transition-colors duration-200 hover:bg-teal-700"
  -          onClick={handleSubmit}
  -        >
  -          提交答案
  -        </button>
  +        <Button
  +          variant="primary"
  +          size="sm"
  +          className="self-end px-7 py-2 font-sans"
  +          onClick={handleSubmit}
  +        >
  +          提交答案
  +        </Button>
         )}
  ```

- [ ] **Step 2: Verify compilation**
  Run: `bun run build`
  Expected: Successful compilation, no syntax errors.

- [ ] **Step 3: Commit**
  ```bash
  git add components/FillCard.tsx
  git commit -m "refactor: use beUI Button in FillCard"
  ```

---

### Task 9: Refactor QuizFooter to use beUI StatefulButton and MagneticButton
**Files:**
- Modify: `components/QuizFooter.tsx`

**Interfaces:**
- Consumes: `StatefulButton`, `MagneticButton` from `@/components/motion/button`

- [ ] **Step 1: Modify QuizFooter.tsx**
  Edit [QuizFooter.tsx](file:///d:/workSpace/Code/Project/quizly/components/QuizFooter.tsx) to replace submit and reset buttons:
  ```tsx
  "use client";

  import { StatefulButton, MagneticButton } from "./motion/button";

  interface QuizFooterProps {
    allDone: boolean;
    onSubmitAll: () => void;
    onReset: () => void;
  }

  export default function QuizFooter({ allDone, onSubmitAll, onReset }: QuizFooterProps) {
    return (
      <div className="flex justify-center gap-3 mt-10">
        {!allDone && (
          <StatefulButton
            variant="primary"
            size="lg"
            ripple={true}
            className="px-9 py-3 shadow-[0_2px_8px_rgba(13,148,136,0.25)] font-sans"
            onClick={onSubmitAll}
          >
            提交全部答案
          </StatefulButton>
        )}
        {allDone && (
          <MagneticButton
            variant="secondary"
            size="lg"
            className="px-9 py-3 font-sans"
            onClick={onReset}
          >
            重新作答
          </MagneticButton>
        )}
      </div>
    );
  }
  ```

- [ ] **Step 2: Verify compilation**
  Run: `bun run build`
  Expected: Successful compilation, no syntax errors.

- [ ] **Step 3: Commit**
  ```bash
  git add components/QuizFooter.tsx
  git commit -m "refactor: use beUI Button variants in QuizFooter"
  ```

---

### Task 10: Refactor AdminSidebar to use beUI Tabs
**Files:**
- Modify: `components/AdminSidebar.tsx`

**Interfaces:**
- Consumes: `Tabs`, `TabsList`, `TabsTrigger` from `@/components/motion/tabs`

- [ ] **Step 1: Modify AdminSidebar.tsx**
  Edit [AdminSidebar.tsx](file:///d:/workSpace/Code/Project/quizly/components/AdminSidebar.tsx) to replace select filter dropdown with beUI dynamic sliding Tabs:
  ```tsx
  "use client";

  import type { Question } from "@/lib/types";
  import { useState } from "react";
  import { Tabs, TabsList, TabsTrigger } from "./motion/tabs";

  interface AdminSidebarProps {
    questions: Question[];
    search: string;
    onSearchChange: (v: string) => void;
    typeFilter: string;
    onTypeFilterChange: (v: string) => void;
    selectedId: number | null;
    onSelect: (id: number | null) => void;
    onDelete: (id: number) => void;
  }

  const TYPE_LABELS: Record<string, string> = {
    "": "全部",
    "单选题": "单选",
    "判断题": "判断",
    "填空题": "填空",
  };

  export default function AdminSidebar({
    questions,
    search,
    onSearchChange,
    typeFilter,
    onTypeFilterChange,
    selectedId,
    onSelect,
    onDelete,
  }: AdminSidebarProps) {
    const [confirmDelete, setConfirmDelete] = useState<number | null>(null);

    const filtered = questions.filter((q, i) => {
      if (typeFilter && q.type !== typeFilter) return false;
      if (search) {
        const haystack = [q.text, ...(q as any).options?.map((o: any) => o.text) ?? [], ...(q as any).blanks ?? []].join(" ");
        return haystack.toLowerCase().includes(search.toLowerCase());
      }
      return true;
    });

    return (
      <aside className="w-[340px] flex-shrink-0 bg-white border-r border-slate-200 flex flex-col h-screen sticky top-0">
        {/* Toolbar */}
        <div className="p-4 border-b border-slate-200 space-y-3">
          <h2 className="text-base font-bold text-slate-900">题目管理</h2>

          <input
            type="text"
            placeholder="搜索题干或选项…"
            className="w-full px-3 py-2 text-sm border border-slate-200 rounded-lg outline-none focus:border-teal-500 focus:ring-1 focus:ring-teal-500 transition"
            value={search}
            onChange={(e) => onSearchChange(e.target.value)}
          />

          <Tabs
            value={typeFilter}
            onValueChange={onTypeFilterChange}
            variant="segment"
            className="w-full"
          >
            <TabsList className="w-full justify-between">
              {Object.entries(TYPE_LABELS).map(([val, label]) => (
                <TabsTrigger key={val} value={val} className="flex-1 text-xs px-1 py-1">
                  {label}
                </TabsTrigger>
              ))}
            </TabsList>
          </Tabs>

          <div className="text-xs text-slate-500">
            共 {questions.length} 题，筛选 {filtered.length} 题
          </div>
        </div>

        {/* List */}
        <div className="flex-1 overflow-y-auto">
          {filtered.map((q, idx) => {
            const realIdx = questions.indexOf(q);
            const isSelected = selectedId === realIdx;
            const needConfirm = confirmDelete === realIdx;
            const preview = q.text.length > 40 ? q.text.slice(0, 40) + "…" : q.text;

            return (
              <div
                key={realIdx}
                className={[
                  "flex items-start gap-2.5 px-4 py-3 cursor-pointer border-b border-slate-100 transition-colors",
                  isSelected ? "bg-teal-50 border-l-4 border-l-teal-600" : "hover:bg-slate-50",
                ].join(" ")}
                onClick={() => onSelect(realIdx)}
              >
                <span className="text-xs font-bold text-teal-600 bg-teal-50 px-2 py-0.5 rounded-full flex-shrink-0 mt-0.5">
                  {realIdx + 1}
                </span>
                <span className="text-[10px] font-semibold text-teal-600 bg-teal-50 px-1.5 py-0.5 rounded-full flex-shrink-0 mt-0.5">
                  {q.type}
                </span>
                <span className="flex-1 text-sm text-slate-700 truncate">{preview}</span>

                <button
                  className={[
                    "flex-shrink-0 w-6 h-6 rounded flex items-center justify-center text-xs transition",
                    needConfirm
                      ? "bg-red-600 text-white"
                      : "text-slate-400 hover:text-red-500 hover:bg-red-50",
                  ].join(" ")}
                  onClick={(e) => {
                    e.stopPropagation();
                    if (needConfirm) {
                      onDelete(realIdx);
                      setConfirmDelete(null);
                    } else {
                      setConfirmDelete(realIdx);
                    }
                  }}
                  title={needConfirm ? "确认删除" : "删除"}
                >
                  {needConfirm ? "✓" : "×"}
                </button>
              </div>
            );
          })}
        </div>
      </aside>
    );
  }
  ```

- [ ] **Step 2: Verify compilation**
  Run: `bun run build`
  Expected: Successful compilation, no syntax errors.

- [ ] **Step 3: Commit**
  ```bash
  git add components/AdminSidebar.tsx
  git commit -m "refactor: use beUI Tabs in AdminSidebar"
  ```

---

### Task 11: Refactor AdminQuestionEditor and AdminPage
**Files:**
- Modify: `components/AdminQuestionEditor.tsx`
- Modify: `app/admin/page.tsx`

**Interfaces:**
- Consumes: `Button` from `@/components/motion/button`, `Tabs`, `TabsList`, `TabsTrigger` from `@/components/motion/tabs`

- [ ] **Step 1: Modify AdminQuestionEditor.tsx**
  Edit [AdminQuestionEditor.tsx](file:///d:/workSpace/Code/Project/quizly/components/AdminQuestionEditor.tsx) to replace editor buttons with beUI `Button` and choice filter with beUI `Tabs`:
  ```tsx
  "use client";

  import type { Question, Option, ChoiceQuestion, FillQuestion } from "@/lib/types";
  import { useState, useEffect } from "react";
  import { Button } from "./motion/button";
  import { Tabs, TabsList, TabsTrigger } from "./motion/tabs";

  interface AdminQuestionEditorProps {
    question: Question;
    index: number;
    onSave: (q: Question) => void;
    isNew: boolean;
  }

  type Draft = {
    type: "单选题" | "判断题" | "填空题";
    text: string;
    options?: Option[];
    answer: string | string[];
    blanks?: string[];
  };

  function emptyDraft(type: Draft["type"]): Draft {
    if (type === "填空题") return { type, text: "", answer: ["答案 1"], blanks: ["答案 1"] };
    const labels = type === "判断题" ? ["A", "B"] : ["A", "B", "C", "D"];
    const texts = type === "判断题" ? ["正确", "错误"] : ["选项 A", "选项 B", "选项 C", "选项 D"];
    return {
      type,
      text: "",
      options: labels.map((l, i) => ({ label: l, text: texts[i] })),
      answer: labels[0],
    };
  }

  export default function AdminQuestionEditor({
    question,
    index,
    onSave,
    isNew,
  }: AdminQuestionEditorProps) {
    const [draft, setDraft] = useState<Draft>(() => {
      const d = emptyDraft(question.type);
      d.text = question.text;
      if ("options" in question) d.options = question.options;
      d.answer = question.answer;
      if ("blanks" in question) d.blanks = (question as FillQuestion).blanks;
      return d;
    });

    useEffect(() => {
      const d = emptyDraft(question.type);
      d.text = question.text;
      if ("options" in question) d.options = question.options;
      d.answer = question.answer;
      if ("blanks" in question) d.blanks = (question as FillQuestion).blanks;
      setDraft(d);
    }, [question]);

    const push = () => {
      const q: Question = {
        type: draft.type,
        text: draft.text,
        answer: draft.answer,
        ...(draft.options ? { options: draft.options } : {}),
        ...(draft.blanks ? { blanks: draft.blanks } : {}),
      } as Question;
      onSave(q);
    };

    const setText = (v: string) => setDraft((d) => ({ ...d, text: v }));

    const updateOption = (i: number, field: "label" | "text", v: string) => {
      setDraft((d) => {
        if (!d.options) return d;
        const opts = [...d.options];
        opts[i] = { ...opts[i], [field]: v };
        return { ...d, options: opts };
      });
    };

    const setAnswerLabel = (v: string) => setDraft((d) => ({ ...d, answer: v }));

    const addOption = () => {
      setDraft((d) => {
        const opts = [...(d.options ?? [])];
        const nextLabel = String.fromCharCode(65 + opts.length);
        opts.push({ label: nextLabel, text: `选项 ${nextLabel}` });
        return { ...d, options: opts };
      });
    };

    const removeOption = (i: number) => {
      setDraft((d) => {
        if (!d.options) return d;
        const opts = d.options.filter((_, j) => j !== i);
        const ans = d.answer as string;
        const removed = d.options[i]?.label ?? "";
        const newAnswer = ans === removed ? (opts[0]?.label ?? "") : ans;
        return { ...d, options: opts, answer: newAnswer };
      });
    };

    const addBlank = () => {
      setDraft((d) => {
        const arr = [...(d.blanks ?? []), `答案 ${(d.blanks?.length ?? 0) + 1}`];
        return { ...d, blanks: arr, answer: arr };
      });
    };

    const updateBlank = (i: number, v: string) => {
      setDraft((d) => {
        const blanks = [...(d.blanks ?? [])];
        const answer = [...(d.answer as string[])];
        blanks[i] = v;
        answer[i] = v;
        return { ...d, blanks, answer };
      });
    };

    const removeBlank = (i: number) => {
      setDraft((d) => {
        const blanks = (d.blanks ?? []).filter((_, j) => j !== i);
        const answer = (d.answer as string[]).filter((_, j) => j !== i);
        return { ...d, blanks, answer };
      });
    };

    return (
      <div className="flex-1 overflow-y-auto p-6">
        <div className="max-w-2xl mx-auto space-y-5">
          <div className="flex items-center gap-3">
            {!isNew && (
              <span className="text-sm font-bold text-teal-600 bg-teal-50 px-3 py-1 rounded-full">
                第 {index + 1} 题
              </span>
            )}
            <span className="text-sm font-semibold text-slate-500 bg-slate-100 px-3 py-1 rounded-full">
              {draft.type}
            </span>
          </div>

          <Tabs
            value={draft.type}
            onValueChange={(val: any) => setDraft((d) => ({ ...d, type: val }))}
            variant="segment"
            className="w-[280px]"
          >
            <TabsList className="w-full">
              <TabsTrigger value="单选题" className="flex-1">单选</TabsTrigger>
              <TabsTrigger value="判断题" className="flex-1">判断</TabsTrigger>
              <TabsTrigger value="填空题" className="flex-1">填空</TabsTrigger>
            </TabsList>
          </Tabs>

          <div>
            <label className="block text-sm font-semibold text-slate-700 mb-1.5">题干</label>
            <textarea
              className="w-full px-4 py-3 border border-slate-200 rounded-lg outline-none focus:border-teal-500 focus:ring-1 focus:ring-teal-500 resize-y min-h-[80px] text-sm"
              value={draft.text}
              onChange={(e) => setText(e.target.value)}
              placeholder="输入题干内容…"
            />
          </div>

          {draft.type !== "填空题" && (
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <label className="text-sm font-semibold text-slate-700">选项</label>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={addOption}
                  className="text-xs text-teal-600 hover:text-teal-700 font-semibold px-2 h-7"
                >
                  + 添加选项
                </Button>
              </div>

              {(draft.options ?? []).map((opt: Option, i: number) => (
                <div key={i} className="flex items-center gap-2">
                  <input
                    value={opt.label}
                    onChange={(e) => updateOption(i, "label", e.target.value)}
                    className="w-10 px-2 py-2 text-sm border border-slate-200 rounded text-center font-bold outline-none focus:border-teal-500"
                  />
                  <input
                    value={opt.text}
                    onChange={(e) => updateOption(i, "text", e.target.value)}
                    className="flex-1 px-3 py-2 text-sm border border-slate-200 rounded outline-none focus:border-teal-500"
                    placeholder="选项内容"
                  />
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => removeOption(i)}
                    className="w-8 h-8 rounded text-slate-400 hover:text-red-500 hover:bg-red-50 transition"
                    title="删除选项"
                  >
                    ×
                  </Button>
                </div>
              ))}

              {typeof draft.answer === "string" && (
                <div>
                  <label className="block text-sm font-semibold text-slate-700 mb-1.5">正确答案</label>
                  <select
                    className="w-full px-3 py-2 text-sm border border-slate-200 rounded-lg outline-none focus:border-teal-500 bg-white"
                    value={draft.answer}
                    onChange={(e) => setAnswerLabel(e.target.value)}
                  >
                    {(draft.options ?? []).map((opt: Option) => (
                      <option key={opt.label} value={opt.label}>
                        {opt.label} — {opt.text}
                      </option>
                    ))}
                  </select>
                </div>
              )}
            </div>
          )}

          {draft.type === "填空题" && (
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <label className="text-sm font-semibold text-slate-700">
                  填空答案（{(draft.blanks ?? []).length} 空）
                </label>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={addBlank}
                  className="text-xs text-teal-600 hover:text-teal-700 font-semibold px-2 h-7"
                >
                  + 添加空位
                </Button>
              </div>

              {(draft.blanks ?? []).map((_: string, i: number) => (
                <div key={i} className="flex items-center gap-2">
                  <span className="text-xs font-bold text-slate-500 w-6 text-center">{i + 1}.</span>
                  <input
                    value={(draft.answer as string[])[i]}
                    onChange={(e) => updateBlank(i, e.target.value)}
                    className="flex-1 px-3 py-2 text-sm border border-slate-200 rounded outline-none focus:border-teal-500"
                    placeholder={`第 ${i + 1} 空答案`}
                  />
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => removeBlank(i)}
                    className="w-8 h-8 rounded text-slate-400 hover:text-red-500 hover:bg-red-50 transition"
                    title="删除空位"
                  >
                    ×
                  </Button>
                </div>
              ))}
            </div>
          )}

          <div className="flex gap-3 pt-2">
            <Button
              variant="primary"
              size="md"
              onClick={push}
              className="px-8 py-2.5"
            >
              {isNew ? "创建题目" : "保存修改"}
            </Button>
          </div>
        </div>
      </div>
    );
  }
  ```

- [ ] **Step 2: Modify app/admin/page.tsx**
  Edit [page.tsx](file:///d:/workSpace/Code/Project/quizly/app/admin/page.tsx) to replace the admin layout buttons:
  ```diff
  --- d:/workSpace/Code/Project/quizly/app/admin/page.tsx
  +++ d:/workSpace/Code/Project/quizly/app/admin/page.tsx
  @@ -7,2 +7,3 @@
   import AdminQuestionEditor from "@/components/AdminQuestionEditor";
  +import { Button } from "@/components/motion/button";
   
  @@ -110,23 +111,26 @@
           <div className="flex items-center gap-3 px-6 py-4 bg-white border-b border-slate-200">
  -          <button
  -            onClick={handleNew}
  -            className="px-5 py-2 rounded-full text-sm font-semibold text-white bg-teal-600 hover:bg-teal-700 transition"
  -          >
  -            + 新增题目
  -          </button>
  -
  -          <button
  -            onClick={handleExport}
  -            className="px-5 py-2 rounded-full text-sm font-semibold text-slate-700 bg-slate-100 hover:bg-slate-200 transition"
  -          >
  -            导出 JSON
  -          </button>
  -
  -          <label className="px-5 py-2 rounded-full text-sm font-semibold text-slate-700 bg-slate-100 hover:bg-slate-200 transition cursor-pointer">
  -            导入 JSON
  -            <input
  -              ref={fileInputRef}
  -              type="file"
  -              accept=".json"
  -              className="hidden"
  -              onChange={handleImport}
  -            />
  -          </label>
  +          <Button
  +            variant="primary"
  +            size="sm"
  +            onClick={handleNew}
  +            className="px-5 py-2"
  +          >
  +            + 新增题目
  +          </Button>
  +
  +          <Button
  +            variant="secondary"
  +            size="sm"
  +            onClick={handleExport}
  +            className="px-5 py-2"
  +          >
  +            导出 JSON
  +          </Button>
  +
  +          <Button
  +            variant="secondary"
  +            size="sm"
  +            asChild
  +            className="px-5 py-2 relative cursor-pointer"
  +          >
  +            <label className="cursor-pointer">
  +              导入 JSON
  +              <input
  +                ref={fileInputRef}
  +                type="file"
  +                accept=".json"
  +                className="hidden"
  +                onChange={handleImport}
  +              />
  +            </label>
  +          </Button>
   
  ```
  *(Wait, if `Button` doesn't have `asChild`, we can just wrap the `label` as normal but style it with beUI button class or change `Button` component to a `div` wrapped button. Alternatively, simply use `Button` directly as `<label>` or style a `div` element inside it. Let's make sure the import button works by styling a `label` element using `className` from Button’s secondary variant.)* Let's use:
  ```tsx
            <label className="inline-flex items-center justify-center font-semibold select-none transition-colors duration-200 cursor-pointer h-10 px-5 text-sm gap-2 rounded-full border border-slate-200 bg-white text-slate-700 hover:bg-slate-50">
              导入 JSON
              <input
                ref={fileInputRef}
                type="file"
                accept=".json"
                className="hidden"
                onChange={handleImport}
              />
            </label>
  ```
  This is extremely simple, clean, and avoids component composition limits!

- [ ] **Step 3: Verify compilation**
  Run: `bun run build`
  Expected: Successful compilation, no syntax errors.

- [ ] **Step 4: Commit**
  ```bash
  git add components/AdminQuestionEditor.tsx app/admin/page.tsx
  git commit -m "refactor: use beUI components in admin editor and page"
  ```

---

## Verification Plan

### Automated Tests
- Run Next.js linting: `bun run lint`
- Run production build to verify compilation: `bun run build`

### Manual Verification
- Start dev server: `bun run dev`
- Open `http://localhost:3000` in browser.
- Verify Choice Cards:
  * Cards show 3D tilt perspective glare effect on hover.
  * Selection indicators (circles) glide smoothly bouncily between choices using layout projection.
- Verify Quiz Footer:
  * "提交全部答案" button has interactive ripple effect on press.
  * "重新作答" has magnetic pull follow on hover.
- Verify Admin Dashboard (`http://localhost:3000/admin`):
  * Top bar buttons and save button are styled and spring-animated.
  * Sidebar filters use segment Tabs with sliding active indicators.
  * Editor question type selector uses segment Tabs with sliding active indicators.
