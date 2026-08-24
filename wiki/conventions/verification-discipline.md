---
type: convention
title: Verification and Credential Discipline
description: Four rules for when a system resists you — prove empty results, test capability before answering, never trust in-process counters, never move a live credential out of its session
tags: [verification, agent-discipline, reporting, credentials, safety]
timestamp: 2026-08-24T00:00:00Z
---

# Verification and Credential Discipline

**Applies to every project and every harness.** No scope restriction: personal work, company
work, any language, any tool.

Four rules, one shared situation: **a system resists you, and there is a cheap shortcut that
resolves the friction without resolving the problem.**

| The system does this | The cheap shortcut | What it actually produces |
|---|---|---|
| returns nothing | report "there is none" | your bug, presented as a fact about the world |
| looks like it can't do X | answer "no" from memory | a closed door that was open |
| silently drops your writes | trust your own success counter | a completion claim with no completion |
| demands authentication | extract the credential and replay it | a working script and a leaked secret |

The first three share a failure mode: **reporting your own bug as an external fact.** That is worse
than being wrong — being wrong gets caught, whereas a false *fact* gets believed, written down,
and built on, so the cost keeps compounding after you have moved on. Each reduces to one question:
**is this claim about the world, or about my own code?**

The fourth is not a truth problem but a safety one, and it belongs here because the moment of
temptation is identical: the friction is real, the shortcut works, and taking it costs something
you will not notice until later.

---

## 1. An empty result must be proven, not reported

When a query, search, scan, or listing returns nothing — **no rows, no matches, not found,
zero files** — you have two indistinguishable candidates:

- the source genuinely holds nothing, or
- your selector, filter, path, credential, or assumption failed to match.

They look identical from the outside. **Do not report the first until you have ruled out the
second.**

Ways to rule it out, cheapest first:

- **Read what the source itself says.** Most systems distinguish "no data" from "no access" or
  "bad query" in their own words. Go find those words rather than inferring from a count.
- **Widen the match and retry.** If a broader pattern returns rows, your narrow one was the bug.
- **Run the same code path against a known-good neighbour.** If a sibling case returns data and
  this one does not, the difference is real; if the sibling also returns nothing, suspect your code.
- **Check the status, not just the payload.** An error answered with an empty collection is a
  classic impersonation of missing data — test the status before you trust the array.

State which of these you did. "I found nothing" is not a finding; "the source reports none, and
the same query returns rows for a sibling" is.

## 2. A capability question gets tested before it gets answered

When asked *can you do X* / *can you reach Y*, **make one real attempt, then answer.**

Answering from recollection is the most expensive kind of wrong: a false "no" makes the requester
abandon a route that was actually open, and they have no reason to re-ask. A false "yes" is caught
in seconds; a false "no" can be believed for months.

One call is almost always cheap relative to that. If a real attempt is genuinely costly or
destructive, say what you would try and what makes it expensive — do not substitute a guess.

The same rule covers *does this exist*, *is this configured*, *is this supported*.

## 3. An in-process counter is not evidence of effect

A success counter inside your own process records that **you issued an operation and it did not
throw**. It does not record that the operation had its intended effect.

The gap is where silent failures live: a write the destination discarded, a request the sandbox
blocked, a queued action the environment dropped, a partial commit rolled back.

**Close every bulk operation against an external source of truth:**

- the filesystem or datastore itself — count and inspect what actually landed
- the authoritative listing from the source system, diffed item by item
- a fresh read-back through a different path than the one that wrote

Report the externally-verified number, not the counter. When the two disagree, the counter is the
one that is wrong — and the disagreement is itself the finding.

Corollary: **a passing test suite and a correct result are different claims.** Tests prove the
cases you thought of. For bulk work, surveying the whole population is the acceptance check.

## 4. A live credential never leaves the session that issued it

When an authenticated session can do the work but is awkward to drive, the shortcut is to lift the
credential out — copy the session cookie, token, or key somewhere you can replay it from. **Do not.**

Concretely, a live credential does not get: written to a file, committed, pasted into a script,
echoed into logs or a transcript, or handed to a second tool or process so that it can reissue the
request.

Two reasons, and the second is the one that gets underweighted:

- **It outlives the task.** The session expires on its own schedule; a file does not. Whatever you
  wrote it into persists after you have stopped thinking about it, in a place chosen for
  convenience rather than for protection.
- **Replaying it moves the request outside whatever was guarding the original path.** The session
  had constraints — origin, scope, expiry, an audit trail. A replay from elsewhere keeps the
  authority and drops the constraints.

**Instead:** do the work *inside* the authenticated session. If the session genuinely cannot do it,
say what is blocked and ask — an awkward supported path beats a smooth unsupported one.

**If a guard stops you, the guard is the finding, not the obstacle.** Being blocked from moving a
credential is the system working. Report it and pick a different approach; do not look for a way
around it, and do not treat "it was the only way to finish" as justification.

---

## How this shows up in practice

Worked examples live in the pages where the work happened, each one placed beside the rule it cost
and citing that rule by number and name:

- [statement acquisition — Chase](../knowledge/statement-acquisition-chase.md)
- [statement acquisition — Bank of America](../knowledge/statement-acquisition-boa.md)
