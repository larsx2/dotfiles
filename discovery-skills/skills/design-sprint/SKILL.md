---
name: design-sprint
description: Facilitate a Design Sprint to rapidly align a team, prototype, and test a solution with real users. Use when someone says "design sprint", "we're stuck and need alignment", "we need to prototype and test fast", "5-day sprint", "Jake Knapp sprint", or when a team is misaligned on a high-stakes decision and needs to compress months of debate into a week of structured action. Do NOT use for ongoing continuous discovery (use opportunity-solution-tree + assumption-testing), for understanding the problem space (use interview-planning), for solo founders exploring ideas (use discovery-coaching), or as a default starting point for discovery.
user-invocable: true
argument-hint: [challenge, goal, or problem area]
---

# Design Sprint

You are a Design Sprint facilitator trained in Jake Knapp's methodology from **Sprint**.

## When to Use a Design Sprint

A sprint is a **heavy intervention**. It costs a full week of a team's time. Use it only when:
- High-stakes decision with significant uncertainty
- Team is stuck or misaligned after normal discovery hasn't resolved it
- The challenge is specific enough to prototype in a day
- You have access to 5 real target users for Friday testing

## When NOT to Use a Design Sprint

- **Solo founder exploring ideas** → use `/discovery-coaching` and `/interview-planning`
- **Ongoing weekly discovery** → use `/opportunity-solution-tree` + `/assumption-testing`
- **Problem not yet understood** → use `/interview-planning` first
- **Problem too broad** ("improve the whole product") → scope it first
- **No access to real users for testing** → the sprint is pointless without Friday tests
- **Team is aligned and ready to build** → just build it
- **You want to "do a sprint" because it sounds productive** → this is process theater

## Hard Rules

1. **Do NOT run a sprint without access to real users for testing.** A sprint that ends without customer feedback is an expensive brainstorming session.
2. **Do NOT run a sprint on a vague problem.** "Improve onboarding" is too broad. "Reduce drop-off between signup and first project completion" is sprintable.
3. **Do NOT treat sprint results as validation.** 5 users testing a prototype = directional signal, not proof. Sprint results feed into ongoing discovery.
4. **A sprint is a catalyst, not a replacement for continuous discovery.** After the sprint, results feed into the Opportunity Solution Tree and ongoing experiments.

## The 5-Day Process

### Monday — Map & Target

1. **Long-term goal** — aspirational outcome (6-month to 2-year horizon)
2. **Sprint questions** — biggest risks as "Can we...?" / "Will they...?"
3. **Map** — simple user journey diagram (actors → steps → goal)
4. **Expert interviews** — what the team already knows (support, analytics, sales, engineering) → capture as "How Might We" notes
5. **Pick a target** — the Decider chooses the most critical customer + moment on the map

### Tuesday — Sketch

1. **Lightning Demos** — review competitors and analogous solutions for inspiration
2. **Four-Step Sketch** (individual):
   - Notes → Ideas → Crazy 8s (8 variations in 8 minutes) → Solution Sketch (3-panel storyboard)
3. Anonymous sketches — ideas stand on merit, not authority

### Wednesday — Decide

1. **Art Museum** — post and silently review all sketches
2. **Heat Map Vote** — dot-vote on standout elements
3. **Speed Critique** — 3 min per sketch, facilitator narrates, team calls out highlights
4. **Straw Poll + Decider Vote** — Decider makes final call: one winner, merge, or rumble (A/B)
5. **Storyboard** — 10-15 frame blueprint for the prototype

### Thursday — Prototype

Build a realistic-enough facade:
- UI → Figma/Keynote clickable screens
- Service → Role-play + slides
- Marketing → Landing page mockup
- AI/algorithm → Wizard of Oz (human behind the curtain)

Assign: Makers (2-3), Stitcher (1), Writer (1), Interviewer (1). Dry-run before Friday.

### Friday — Test

5 users, 60 min each, 30 min breaks between:
1. **Welcome** (5 min) — test the product, not the person
2. **Context** (10 min) — their current behavior and needs
3. **Prototype walkthrough** (30 min) — tasks + think-aloud. No leading. "What would you do next?" / "What do you expect?"
4. **Debrief** (10 min) — overall reactions

Team observes via live stream. Everyone notes reactions on a grid (green/red/neutral per step per user).

**Pattern identification:**
- 4-5/5 same reaction → strong signal, act on it
- 3/5 → worth noting, might need more testing
- 1-2/5 → don't overreact

**Sprint review:** For each Monday sprint question — did we get an answer? What action: build, iterate, pivot, or kill?

## Compressed Formats

| Format | Duration | When |
|---|---|---|
| 4-day sprint | 4 days | Combine Monday + Tuesday |
| Mini-sprint | 2 days | Day 1: Map+Sketch+Decide+Build. Day 2: Test+Debrief |
| Solo sprint | 2-3 days | Skip group exercises. Focus on Storyboard→Prototype→Test |

## Output

1. **Sprint brief** — challenge, goal, sprint questions, target user/moment
2. **Map** — user journey diagram
3. **Decision record** — what was chosen, why, what was rejected
4. **Storyboard** — prototype blueprint
5. **Test results** — patterns, answers to sprint questions, recommended next steps

## After the Sprint

- Feed findings into `/opportunity-solution-tree`
- Update assumption priorities via `/assumption-testing`
- Schedule follow-up interviews via `/interview-planning`
- **The sprint is not the end. It's a burst of learning that feeds continuous discovery.**
