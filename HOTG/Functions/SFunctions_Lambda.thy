\<^marker>\<open>creator "Kevin Kappelmann"\<close>
subsection \<open>Lambda Abstractions\<close>
theory SFunctions_Lambda
  imports SFunctions_Base
begin

definition "lambda A f \<equiv> {\<langle>x, f x\<rangle> | x \<in> A}"

bundle hotg_lambda_syntax
begin
syntax
  "_lam"  :: "[pttrns, set, set \<Rightarrow> set] \<Rightarrow> set" ("(2\<lambda>_ \<in> _./ _)" 60)
  "_lam2" :: "[pttrns, set, set \<Rightarrow> set] \<Rightarrow> set"
end
bundle no_hotg_lambda_syntax
begin
no_syntax
  "_lam"  :: "[pttrns, set, set \<Rightarrow> set] \<Rightarrow> set" ("(2\<lambda>_ \<in> _./ _)" 60)
  "_lam2" :: "[pttrns, set, set \<Rightarrow> set] \<Rightarrow> set"
end
unbundle hotg_lambda_syntax

translations
  "\<lambda>x xs \<in> A. f" \<rightharpoonup> "CONST lambda A (\<lambda>x. _lam2 xs A f)"
  "_lam2 x A f" \<rightharpoonup> "\<lambda>x \<in> A. f"
  "\<lambda>x \<in> A. f" \<rightleftharpoons> "CONST lambda A (\<lambda>x. f)"

lemma mem_lambdaE [elim!]:
  assumes "p \<in> \<lambda>x \<in> A. f x"
  obtains x y where "p = \<langle>x, y\<rangle>" "x \<in> A" "y = f x"
  using assms unfolding lambda_def by auto

lemma mem_lambdaD [dest]: "\<langle>a, b\<rangle> \<in> \<lambda>x \<in> A. f x \<Longrightarrow> b = f a"
  by auto

lemma lambda_cong [cong]:
  "\<lbrakk>A = A'; \<And>x. x \<in> A \<Longrightarrow> f x = f' x\<rbrakk> \<Longrightarrow> (\<lambda>x \<in> A. f x) = \<lambda>x \<in> A'. f' x"
  unfolding lambda_def by auto

lemma eval_lambda_eq [simp]: "a \<in> A \<Longrightarrow> (\<lambda>x \<in> A. f x)`a = f a"
  unfolding lambda_def by auto

lemma eval_lambda_uncurry_eq [simp]:
  assumes "x \<in> A" "y \<in> B x"
  shows "(\<lambda>p \<in> \<Sum>x \<in> A. (B x). uncurry f p)`\<langle>x, y\<rangle> = f x y"
  using assms by auto

lemma lambda_dep_pairs_eq_lambda_uncurry:
  "(\<lambda>p \<in> \<Sum>x \<in> A. (B x). f p) = (\<lambda>\<langle>a, b\<rangle> \<in> \<Sum>x \<in> A. (B x). f \<langle>a, b\<rangle>)"
  by (rule lambda_cong) auto

lemma lambda_pair_mem_if_mem [intro]: "a \<in> A \<Longrightarrow> \<langle>a, f a\<rangle> \<in> \<lambda>x \<in> A. f x"
  unfolding lambda_def by auto

lemma lambda_dom_eq [simp]: "dom (\<lambda>x \<in> A. f x) = A"
  unfolding lambda_def by simp

lemma lambda_rng_eq [simp]: "rng (\<lambda>x \<in> A. f x) = {f x | x \<in> A}"
  unfolding lambda_def by simp

lemma app_eq_if_mem_if_lambda_eq:
  "\<lbrakk>(\<lambda>x \<in> A. f x) = \<lambda>x \<in> A. g x; a \<in> A\<rbrakk> \<Longrightarrow> f a = g a"
  by auto

lemma lambda_mem_dep_functions [iff]: "(\<lambda>x \<in> A. f x) \<in> (x \<in> A) \<rightarrow>s {f x}"
  by auto

lemma lambda_mem_dep_functions_contravariant:
  assumes "f \<in> (x \<in> A) \<rightarrow>s (B x)"
  and "A' \<subseteq> A"
  shows "(\<lambda>a \<in> A'. f`a) \<in> (x \<in> A') \<rightarrow>s (B x)"
proof
  show "(\<lambda>a \<in> A'. f`a) \<subseteq> \<Sum>x \<in> A'. (B x)"
  proof
    fix p assume "p \<in> \<lambda>a \<in> A'. f`a"
    then obtain x y where "x \<in> A'" "y \<in> {f`x}" "p = \<langle>x, y\<rangle>" by auto
    moreover with assms have "y \<in> B x" by auto
    ultimately show "p \<in> \<Sum>x \<in> A'. (B x)" by auto
  qed
qed auto

lemma lambda_bin_inter_mem_dep_functionsI:
  assumes "f \<in> (x \<in> A) \<rightarrow>s (B x)"
  shows "(\<lambda>x \<in> A \<inter> A'. f`x) \<in> (x \<in> A \<inter> A') \<rightarrow>s (B x)"
  using assms by (rule lambda_mem_dep_functions_contravariant) auto

lemma lambda_ext:
  assumes "f \<in> (x \<in> A) \<rightarrow>s (B x)"
  and "\<And>a. a \<in> A \<Longrightarrow> g a = f`a"
  shows "(\<lambda>a \<in> A. g a) = f"
  using assms by (intro eqI) auto

lemma lambda_eta [simp]: "f \<in> (x \<in> A) \<rightarrow>s (B x) \<Longrightarrow> (\<lambda>x \<in> A. f`x) = f"
  by (rule dep_functions_ext,
    rule mem_dep_functions_covariant_codom[OF lambda_mem_dep_functions]) auto

text \<open>Every element of @{term "(x \<in> A) \<rightarrow>s (B x)"} may be expressed as a
lambda abstraction\<close>
lemma eq_lambdaE_if_mem_dep_functions:
  assumes "f \<in> (x \<in> A) \<rightarrow>s (B x)"
  obtains g where "f = (\<lambda>x \<in> A. g x)"
proof
  let ?g="(\<lambda>x. f`x)"
  from assms show "f = (\<lambda>x \<in> A. (\<lambda>x. f`x) x)" by auto
qed

lemma mono_lambda_set: "mono (\<lambda>A. \<lambda>x \<in> A. f x)"
  by (intro monoI) auto


end