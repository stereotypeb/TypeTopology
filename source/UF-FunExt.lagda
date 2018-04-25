Formulation of function extensionality

\begin{code}

{-# OPTIONS --without-K --exact-split #-}

module UF-FunExt where

open import UF-Base
open import UF-Equiv
open import UF-LeftCancellable

FunExt : ∀ U V → U ′ ⊔ V ′ ̇
FunExt U V = {X : U ̇} {A : X → V ̇} (f g : Π A) → isEquiv (happly' f g)

≃-funext : ∀ U V → FunExt U V → {X : U ̇} {A : X → V ̇} (f g : Π A)
         → (f ≡ g) ≃ ((x : X) → f x ≡ g x)
≃-funext U V fe f g = happly' f g , fe f g

funext : ∀ {U V} (fe : FunExt U V) {X : U ̇} {A : X → V ̇} {f g : Π A} 
       → ((x : X) → f x ≡ g x) → f ≡ g
funext fe {X} {A} {f} {g} = pr₁(pr₁(fe f g))

happly-funext : ∀ {U V} {X : U ̇} {A : X → V ̇}
                (fe : FunExt U V) (f g : Π A) (h : f ∼ g)
              → happly (funext fe h) ≡ h
happly-funext fe f g = pr₂(pr₁(fe f g))

funext-lc : ∀ {U V} {X : U ̇} {A : X → V ̇} (fe : FunExt U V) 
         → (f g : Π A) → left-cancellable (funext fe {X} {A} {f} {g})
funext-lc fe f g = section-lc (funext fe) (happly , happly-funext fe f g)

happly-lc : ∀ {U V} {X : U ̇} {A : X → V ̇} (fe : FunExt U V) (f g : Π A) 
         → left-cancellable(happly' f g)
happly-lc fe f g = section-lc happly ((pr₂ (fe f g)))

\end{code}

The following is taken from this thread:
https://groups.google.com/forum/#!msg/homotopytypetheory/VaLJM7S4d18/Lezr_ZhJl6UJ

\begin{code}

transport-funext : ∀ {U V W} {X : U ̇} (A : X → V ̇) (P : (x : X) → A x → W ̇) (fe : FunExt U V)
                   (f g : Π A)
                   (φ : (x : X) → P x (f x))
                   (h : f ∼ g)
                   (x : X)
                 → (transport (λ (u : Π A) → (x : X) → P x (u x)) (funext fe h) φ) x
                 ≡  transport (P x) (h x) (φ x)
transport-funext A P fe f g φ h x = q ∙ r
 where
  l : (f g : Π A) (φ : ∀ x → P x (f x)) (p : f ≡ g) 
        → ∀ x → (transport (λ (u : Π A) → ∀ x → P x (u x)) p φ) x
               ≡ transport (P x) (happly p x) (φ x)
  l f .f φ refl x = refl

  q : (transport (λ (u : Π A) → ∀ x → P x (u x)) (funext fe h) φ) x
    ≡ transport (P x) (happly (funext fe h) x) (φ x)
  q = l f g φ (funext fe h) x

  r :  transport (P x) (happly (funext fe h) x) (φ x) 
     ≡ transport (P x) (h x) (φ x)
  r = ap (λ h → transport (P x) (h x) (φ x)) (happly-funext fe f g h)

\end{code}