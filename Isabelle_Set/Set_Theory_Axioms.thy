theory Set_Theory_Axioms
imports Notation_Cleanup

begin

section \<open> Axiomatic basis of higher-order Tarski-Grothendieck set theory embedded in HOL. \<close>

text \<open>
We axiomatize a type \<open>set\<close>, with the standard set-theoretic operations and axioms.
\<close>

typedecl set

axiomatization
  elem :: "set \<Rightarrow> set \<Rightarrow> bool" (infixl "\<in>" 50) and
  empty_set :: set ("{}") and
  Pow :: "set \<Rightarrow> set" and
  Union :: "set \<Rightarrow> set" ("\<Union>_" [90] 90) and
  Repl :: "set \<Rightarrow> (set \<Rightarrow> set) \<Rightarrow> set"
where
  elem_induct_axiom: "(\<forall>X. (\<forall>x. x \<in> X \<longrightarrow> P x) \<longrightarrow> P X) \<longrightarrow> (\<forall>X. P X)"
and
  empty_axiom [simp]: "\<not>(\<exists>x. x \<in> {})"
and
  Union_axiom [iff]: "\<forall>X x. x \<in> \<Union>X \<longleftrightarrow> (\<exists>Y. Y \<in> X \<and> x \<in> Y)"
and
  Replacement_axiom [iff]: "\<forall>X y. y \<in> Repl X F \<longleftrightarrow> (\<exists>x. x \<in> X \<and> y = F x)"

text \<open>Axioms @{thm elem_induct_axiom} and @{thm Replacement_axiom} are axiom schemas in first-order logic.\<close>


text \<open>The following axioms need a definition first:\<close>

definition subset :: "set \<Rightarrow> set \<Rightarrow> bool" (infixl "\<subseteq>" 50) \<comment> \<open>subset relation\<close>
  where subset_def: "A \<subseteq> B \<equiv> (\<forall>x. x \<in> A \<longrightarrow> x \<in> B)"

axiomatization where
  extensionality_axiom: "\<forall>X Y. X \<subseteq> Y \<longrightarrow> Y \<subseteq> X \<longrightarrow> X = Y"
and
  Pow_axiom: "\<forall>A x. x \<in> Pow A \<longleftrightarrow> x \<subseteq> A"


text \<open>
Finally, we axiomatize the constant \<open>Univ\<close>, which, given a set, returns a Grothendieck universe containing the set.

This is the Tarski axiom.
\<close>

definition transitive :: "set \<Rightarrow> bool"
  where "transitive X \<equiv> (\<forall>x. x \<in> X \<longrightarrow> x \<subseteq> X)"

definition ZF_closed :: "set \<Rightarrow> bool"
  where "ZF_closed U \<equiv> (
      (\<forall>X. X \<in> U \<longrightarrow> \<Union>X \<in> U) \<and>
      (\<forall>X. X \<in> U \<longrightarrow> Pow X \<in> U) \<and>
      (\<forall>X F. X \<in> U \<longrightarrow> (\<forall>x. x \<in> X \<longrightarrow> F x \<in> U) \<longrightarrow> Repl X F \<in> U)
    )"

text \<open>Remark: @{const ZF_closed} is a second-order statement.\<close>


axiomatization
  Univ :: "set \<Rightarrow> set"
where
  Univ_member: "X \<in> Univ X"
and
  Univ_transitive: "transitive (Univ X)"
and
  Univ_ZF_closed: "ZF_closed (Univ X)"


end