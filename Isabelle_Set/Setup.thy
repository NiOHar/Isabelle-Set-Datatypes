chapter \<open>Setup\<close>

theory Setup
imports "../Soft_Types/Soft_Types_HOL" Rewrite

begin


section \<open>Combinators\<close>

abbreviation (input) "K x \<equiv> \<lambda>_. x"
abbreviation (input) "app2 f x \<equiv> f x x"
abbreviation (input) comp (infixl "o" 55) where "g o f \<equiv> \<lambda>x. g (f x)"


section \<open>Notation\<close>

declare [[eta_contract=false]]

text \<open>Remove conflicting HOL-specific syntax.\<close>

no_notation (ASCII)
  Not ("~ _" [40] 40) and
  conj (infixr "&" 35) and
  disj (infixr "|" 30) and
  implies (infixr "-->" 25) and
  not_equal (infixl "~=" 50)

no_syntax "_Let" :: "[letbinds, 'a] \<Rightarrow> 'a" ("(let (_)/ in (_))" 10)

no_notation Pure.eq (infix "\<equiv>" 2)
notation Pure.eq ("(1_ \<equiv>/ _)" [3, 3] 2) \<comment>\<open>Just some prettier formatting\<close>


section \<open>Additional logical rules\<close>

lemma True_simp: "P \<equiv> True \<Longrightarrow> P" by simp

lemma disjCI2: "(\<not>A \<Longrightarrow> B) \<Longrightarrow> A \<or> B" by blast

lemma contrapos: "P \<longrightarrow> Q \<Longrightarrow> \<not>Q \<longrightarrow> \<not>P" by blast

lemma ex1_iff:
  "(\<exists>!x. P x) \<longleftrightarrow> (\<exists>x. P x) \<and> (\<forall>x x'. P x \<and> P x' \<longrightarrow> x = x')"
  by blast

lemma noncontr: "\<lbrakk>P; \<not>P\<rbrakk> \<Longrightarrow> False" by auto


end
