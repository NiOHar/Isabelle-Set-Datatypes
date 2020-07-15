chapter \<open>Higher-order Tarski-Grothendieck set theory\<close>

theory Set_Theory
imports Axioms

begin


section \<open>Preliminaries\<close>

abbreviation not_mem (infixl "\<notin>" 50)
  where "x \<notin> y \<equiv> \<not> x \<in> y"


section \<open>Foundational axioms as rules\<close>

lemma emptyset [simp]: "x \<notin> {}" using emptyset by blast

lemmas
  extensionality = extensionality[rule_format] and
  mem_induction = mem_induction[rule_format] and
  union [iff] = union[rule_format] and
  powerset [iff] = powerset[rule_format] and
  replacement [iff] = replacement[rule_format]


section \<open>Bounded quantifiers\<close>

definition ball :: \<open>set \<Rightarrow> (set \<Rightarrow> bool) \<Rightarrow> bool\<close>
  where "ball A P \<equiv> (\<forall>x. x \<in> A \<longrightarrow> P x)"

definition bex :: \<open>set \<Rightarrow> (set \<Rightarrow> bool) \<Rightarrow> bool\<close>
  where "bex A P \<equiv> \<exists>x. x \<in> A \<and> P x"

definition bex1 :: \<open>set \<Rightarrow> (set \<Rightarrow> bool) \<Rightarrow> bool\<close>
  where "bex1 A P \<equiv> \<exists>!x. x \<in> A \<and> P x"

syntax
  "_ball"  :: \<open>[idts, set, bool] \<Rightarrow> bool\<close> ("(2\<forall>_ \<in> _./ _)" 10)
  "_ball2" :: \<open>[idts, set, bool] \<Rightarrow> bool\<close>
  "_bex"   :: \<open>[idts, set, bool] \<Rightarrow> bool\<close> ("(2\<exists>_ \<in> _./ _)" 10)
  "_bex2"  :: \<open>[idts, set, bool] \<Rightarrow> bool\<close>
  "_bex1"  :: \<open>[pttrn, set, bool] \<Rightarrow> bool\<close> ("(2\<exists>!_ \<in> _./ _)" 10)
translations
  "\<forall>x xs \<in> A. P" \<rightharpoonup> "CONST ball A (\<lambda>x. _ball2 xs A P)"
  "_ball2 x A P" \<rightharpoonup> "\<forall>x \<in> A. P"
  "\<forall>x \<in> A. P" \<rightleftharpoons> "CONST ball A (\<lambda>x. P)"

  "\<exists>x xs \<in> A. P" \<rightharpoonup> "CONST bex A (\<lambda>x. _bex2 xs A P)"
  "_bex2 x A P" \<rightharpoonup> "\<exists>x \<in> A. P"
  "\<exists>x \<in> A. P" \<rightleftharpoons> "CONST bex A (\<lambda>x. P)"

  "\<exists>!x \<in> A. P" \<rightleftharpoons> "CONST bex1 A (\<lambda>x. P)"

lemma ballI [intro!]: "\<lbrakk>\<And>x. x \<in> A \<Longrightarrow> P x\<rbrakk> \<Longrightarrow> \<forall>x \<in> A. P x"
  by (simp add: ball_def)

lemma bspec [dest?]: "\<lbrakk>\<forall>x \<in> A. P x; x \<in> A\<rbrakk> \<Longrightarrow> P x"
  by (simp add: ball_def)

lemma ballD: "\<forall>x \<in> A. P x \<Longrightarrow> (\<And>x. x \<in> A \<Longrightarrow> P x)"
  by (simp add: ball_def)

lemma ballE: "\<lbrakk>\<forall>x \<in> A. P x; P x \<Longrightarrow> Q; x \<notin> A \<Longrightarrow> Q\<rbrakk> \<Longrightarrow> Q"
  unfolding ball_def by auto

corollary rev_ballE [elim]: "\<lbrakk>\<forall>x \<in> A. P x; x \<notin> A \<Longrightarrow> Q; P x \<Longrightarrow> Q\<rbrakk> \<Longrightarrow> Q"
  by (rule ballE)

(*LP: Trival rewrite rule: \<open>(\<forall>x \<in> A. P) \<longleftrightarrow> P\<close> holds only if A is nonempty!*)
lemma ball_triv [simp]: "(\<forall>x \<in> A. P) \<longleftrightarrow> ((\<exists>x. x \<in> A) \<longrightarrow> P)"
  by (simp add: ball_def)

lemma ball_cong [cong]:
  "\<lbrakk>A = A'; \<And>x. x \<in> A' \<Longrightarrow> P x \<longleftrightarrow> P' x\<rbrakk> \<Longrightarrow> (\<forall>x \<in> A. P x) \<longleftrightarrow> (\<forall>x \<in> A'. P' x)"
  by (simp add: ball_def)

lemma atomize_ball:
  "(\<And>x. x \<in> A \<Longrightarrow> P x) \<equiv> Trueprop (\<forall>x \<in> A. P x)"
  by (simp only: ball_def atomize_all atomize_imp)

lemmas
  [symmetric, rulify] = atomize_ball and
  [symmetric, defn] = atomize_ball

lemma bexI [intro]: "\<lbrakk>P x; x \<in> A\<rbrakk> \<Longrightarrow> \<exists>x \<in> A. P x"
  by (simp add: bex_def, blast)

(*LP: The best argument order when there is only one @{term "x \<in> A"}*)
corollary rev_bexI: "\<lbrakk>x \<in> A; P x\<rbrakk> \<Longrightarrow> \<exists>x \<in> A. P x" ..

(*LP: Not of the general form for such rules. The existential quantifier becomes
  universal.*)
lemma bexCI: "\<lbrakk>\<forall>x \<in> A. \<not>P x \<Longrightarrow> P a; a \<in> A\<rbrakk> \<Longrightarrow> \<exists>x \<in> A. P x"
  by blast

lemma bexE [elim!]: "\<lbrakk>\<exists>x \<in> A. P x; \<And>x. \<lbrakk>x \<in> A; P x\<rbrakk> \<Longrightarrow> Q\<rbrakk> \<Longrightarrow> Q"
  by (simp add: bex_def, blast)

(*LP: We do not even have @{term "(\<exists>x \<in> A. True) \<longleftrightarrow> True"} unless @{term "A"} is
  nonempty.*)
lemma bex_triv [simp]: "(\<exists>x \<in> A. P) \<longleftrightarrow> ((\<exists>x. x \<in> A) \<and> P)"
  by (simp add: bex_def)

lemma bex_cong [cong]:
  "\<lbrakk>A = A'; \<And>x. x \<in> A' \<Longrightarrow> P x \<longleftrightarrow> P' x\<rbrakk> \<Longrightarrow> (\<exists>x \<in> A. P x) \<longleftrightarrow> (\<exists>x \<in> A'. P' x)"
  by (simp add: bex_def cong: conj_cong)

lemma bex1I [intro]: "\<lbrakk>P x; x \<in> A; \<And>z. \<lbrakk>P z; z \<in> A\<rbrakk> \<Longrightarrow> z = x\<rbrakk> \<Longrightarrow> \<exists>!x \<in> A. P x"
  by (simp add: bex1_def, blast)

lemma rev_bex1I: "\<lbrakk>x \<in> A; P x; \<And>z. \<lbrakk>P z; z \<in> A\<rbrakk> \<Longrightarrow> z = x\<rbrakk> \<Longrightarrow> \<exists>!x \<in> A. P x"
  by blast

lemma bex1E [elim!]: "\<lbrakk>\<exists>!x \<in> A. P x; \<And>x. \<lbrakk>x \<in> A; P x\<rbrakk> \<Longrightarrow> Q\<rbrakk> \<Longrightarrow> Q"
  by (simp add: bex1_def, blast)

lemma bex1_triv [simp]: "(\<exists>!x \<in> A. P) \<longleftrightarrow> ((\<exists>!x. x \<in> A) \<and> P)"
  by (auto simp add: bex1_def)

lemma bex1_iff: "(\<exists>!x \<in> A. P x) \<longleftrightarrow> (\<exists>!x. x \<in> A \<and> P x)"
  by (auto simp add: bex1_def)

lemma bex1_cong [cong]:
  "\<lbrakk>A = A'; \<And>x. x \<in> A' \<Longrightarrow> P x \<longleftrightarrow> P' x\<rbrakk> \<Longrightarrow> (\<exists>!x \<in> A. P x) \<longleftrightarrow> (\<exists>!x \<in> A'. P' x)"
  by (simp add: bex1_def cong: conj_cong)

lemma bex1_implies_bex: "\<exists>!x \<in> A. P x \<Longrightarrow> \<exists>x \<in> A. P x"
  by auto

lemma ball_conj_distrib:
  "(\<forall>x \<in> A. P x \<and> Q x) \<longleftrightarrow> (\<forall>x \<in> A. P x) \<and> (\<forall>x \<in> A. Q x)"
  by auto


section \<open>Bounded definite description\<close>

definition bthe :: "set \<Rightarrow> (set \<Rightarrow> bool) \<Rightarrow> set"
  where "bthe A P \<equiv> The (\<lambda>x. x \<in> A \<and> P x)"

syntax "_bthe" :: "[pttrn, set, bool] \<Rightarrow> set" ("(3THE _ \<in> _./ _)" [0, 0, 10] 10)
translations "THE x \<in> A. P" \<rightleftharpoons> "CONST bthe A (\<lambda>x. P)"

lemma bthe_equality [intro]:
  assumes "P a"
      and "a \<in> A"
      and "\<And>x. \<lbrakk>x \<in> A; P x\<rbrakk> \<Longrightarrow> x = a"
  shows "(THE x \<in> A. P x) = a"
  unfolding bthe_def by (auto intro: assms)

lemma btheI:
  "\<exists>!x \<in> A. P x \<Longrightarrow> (THE x \<in> A. P x) \<in> A \<and> P (THE x \<in> A. P x)"
  unfolding bex1_def bthe_def by (fact theI'[of "\<lambda>x. x \<in> A \<and> P x"])

lemma
  btheI1: "\<exists>!x \<in> A. P x \<Longrightarrow> (THE x \<in> A. P x) \<in> A" and
  btheI2: "\<exists>!x \<in> A. P x \<Longrightarrow> P (THE x \<in> A. P x)"
  by (auto dest!: btheI)

simproc_setup defined_bex ("\<exists>x \<in> A. P x \<and> Q x") =
  \<open>fn _ => Quantifier1.rearrange_bex
    (fn ctxt =>
      unfold_tac ctxt @{thms bex_def} THEN
      Quantifier1.prove_one_point_ex_tac ctxt)\<close>

simproc_setup defined_ball ("\<forall>x \<in> A. P x \<longrightarrow> Q x") =
  \<open>fn _ => Quantifier1.rearrange_ball
    (fn ctxt =>
      unfold_tac ctxt @{thms ball_def} THEN
      Quantifier1.prove_one_point_all_tac ctxt)\<close>


section \<open>Subsets\<close>

lemma subsetI [intro!]: "(\<And>x. x \<in> A \<Longrightarrow> x \<in> B) \<Longrightarrow> A \<subseteq> B"
  by (simp add: subset_def)

lemma subsetE [elim]: "\<lbrakk>A \<subseteq> B; a \<in> A\<rbrakk> \<Longrightarrow> a \<in> B"
  by (unfold subset_def) auto

lemma subsetD: "A \<subseteq> B \<Longrightarrow> a \<in> A \<longrightarrow> a \<in> B"
  by auto

lemma subsetCE [elim]: "\<lbrakk>A \<subseteq> B; a \<notin> A \<Longrightarrow> P; a \<in> B \<Longrightarrow> P\<rbrakk> \<Longrightarrow> P"
  by (simp add: subset_def, blast)

lemma rev_subsetE: "\<lbrakk>a \<in> A; A \<subseteq> B\<rbrakk> \<Longrightarrow> a \<in> B"
  by auto

lemma contra_subsetE: "\<lbrakk>A \<subseteq> B; a \<notin> B\<rbrakk> \<Longrightarrow> a \<notin> A"
  by blast

lemma rev_contra_subsetE: "\<lbrakk>a \<notin> B; A \<subseteq> B\<rbrakk> \<Longrightarrow> a \<notin> A"
  by auto

lemma subset_refl [simp]: "A \<subseteq> A"
  by blast

lemma subset_trans: "\<lbrakk>A \<subseteq> B; B \<subseteq> C\<rbrakk> \<Longrightarrow> A \<subseteq> C"
  by blast

(*LP: Useful for proving A \<subseteq> B by rewriting in some cases*)
lemma subset_iff: "A \<subseteq> B \<longleftrightarrow> (\<forall>x. x \<in> A \<longrightarrow> x \<in> B)"
  unfolding subset_def ..

text \<open>For calculations:\<close>

declare
  subsetE [trans]
  rev_subsetE [trans]
  subset_trans [trans]


section \<open>\<in>-transitivity\<close>

lemma mem_transitiveI [intro]:
  "(\<And>x y. x \<in> X \<Longrightarrow> y \<in> x \<Longrightarrow> y \<in> X) \<Longrightarrow> mem_transitive X"
  unfolding mem_transitive_def by auto

lemma mem_transitiveE [elim]:
  "mem_transitive x \<Longrightarrow> y \<in> x \<Longrightarrow> y \<subseteq> x"
  unfolding mem_transitive_def by auto


section \<open>Set equality\<close>

lemma equalityI: "(\<And>x. x \<in> A \<Longrightarrow> x \<in> B) \<Longrightarrow> (\<And>x. x \<in> B \<Longrightarrow> x \<in> A) \<Longrightarrow> A = B"
  by (rule extensionality) auto

lemma equalityI': "(\<And>x. x \<in> A \<longleftrightarrow> x \<in> B) \<Longrightarrow> A = B"
  by (rule extensionality) auto

lemma equalityE: "\<lbrakk>A = B; \<lbrakk>A \<subseteq> B ; B \<subseteq> A\<rbrakk> \<Longrightarrow> P\<rbrakk> \<Longrightarrow> P"
  by blast

lemma equalityCE: "\<lbrakk>A = B; \<lbrakk>a \<in> A; a \<in> B\<rbrakk> \<Longrightarrow> P; \<lbrakk>a \<notin> A; a \<notin> B\<rbrakk> \<Longrightarrow> P\<rbrakk> \<Longrightarrow> P"
  by (erule equalityE, blast)

lemma equalityD: "A = B \<Longrightarrow> (\<And>x. x \<in> A \<longleftrightarrow> x \<in> B)"
  by auto


section \<open>Replacement\<close>

syntax
  "_repl" :: \<open>[set, pttrn, set] => set\<close> ("(1{_ ./ _ \<in> _})")
  "_repl" :: \<open>[set, pttrn, set] => set\<close> ("(1{_ |/ _ \<in> _})")
translations
  "{y | x \<in> A}" \<rightleftharpoons> "CONST repl A (\<lambda>x. y)"
  "{y . x \<in> A}" \<rightharpoonup> "CONST repl A (\<lambda>x. y)"

lemma replI: "a \<in> A \<Longrightarrow> f a \<in> {f x. x \<in> A}"
  by (unfold replacement) auto

(*LP: Useful for coinduction proofs*)
lemma RepFun_eqI [intro]: "\<lbrakk>b = f a; a \<in> A\<rbrakk> \<Longrightarrow> b \<in> {f x. x \<in> A}"
  apply (erule ssubst)
  apply (erule replI)
  done

(*The converse of the above*)
lemma replD:  "b \<in> {f x | x \<in> A} \<Longrightarrow> \<exists>a \<in> A. b = f a"
  by auto

lemma replE [elim!]:
  "\<lbrakk>b \<in> {f x. x \<in> A}; \<And>x. \<lbrakk>x \<in> A; b = f x\<rbrakk> \<Longrightarrow> P\<rbrakk> \<Longrightarrow> P"
  by auto

lemma repl_cong [cong]:
  "\<lbrakk>A = B; \<And>x. x \<in> B \<Longrightarrow> f x = g x\<rbrakk> \<Longrightarrow> {f x. x \<in> A} = {g x. x \<in> B}"
  by (rule extensionality) auto

lemma repl_comp [simp]: "{g b | b \<in> {f a | a \<in> A}} = {g (f a) | a \<in> A}"
  by (rule extensionality) auto

lemma repl_triv [simp]: "{x. x \<in> A} = A"
  by (rule extensionality) auto

lemma repl_empty [iff]: "{f x. x \<in> {}} = {}"
  by (rule extensionality) auto

lemma repl_is_empty [iff]: "{f x. x \<in> A} = {} \<longleftrightarrow> A = {}"
  by (auto dest: equalityD intro!: equalityI')


section \<open>Empty set\<close>

lemma emptyE [elim]: "x \<in> {} \<Longrightarrow> P"
  by auto

lemma empty_subsetI [simp]: "{} \<subseteq> A"
  by auto

lemma equals_emptyI [intro]: "\<lbrakk>\<And>y. y \<in> A \<Longrightarrow> False\<rbrakk> \<Longrightarrow> A = {}"
  by (rule extensionality) auto

lemma equals_emptyD [dest]: "A = {} \<Longrightarrow> a \<notin> A"
  by auto

lemma not_emptyI: "a \<in> A \<Longrightarrow> A \<noteq> {}"
  by auto

lemma not_empty_Ex: "A \<noteq> {} \<Longrightarrow> \<exists>x. x \<in> A"
  by auto

lemma not_emptyE:
  assumes "A \<noteq> {}"
  obtains x where "x \<in> A"
  using not_empty_Ex[OF assms]
  by auto

lemma subset_empty[simp]: "A \<subseteq> {} \<longleftrightarrow> A = {}"
  by auto

lemma emptyset_mem_transitive [intro]: "mem_transitive {}"
  unfolding mem_transitive_def by auto


section \<open>Power set\<close>

lemma powersetI: "A \<subseteq> B \<Longrightarrow> A \<in> powerset B"
  by auto

lemma powersetD: "A \<in> powerset B  \<Longrightarrow> A \<subseteq> B"
  by auto

lemma powerset_bottom [intro]: "{} \<in> powerset A"
  by auto

lemma powerset_top [intro]: "A \<in> powerset A"
  by auto

lemma powerset_empty: "x \<in> powerset {} \<longleftrightarrow> x = {}"
  by auto


section \<open>Unordered pairs, finite sets, singletons\<close>

text \<open>
Define an unordered pair \<open>upair\<close> using replacement, then use it to define
finite sets.
\<close>

definition upair :: \<open>set \<Rightarrow> set \<Rightarrow> set\<close>
  where "upair a b = {if i = {} then a else b | i \<in> powerset (powerset {})}"

definition cons :: \<open>set \<Rightarrow> set \<Rightarrow> set\<close>
  where "cons x A = \<Union>(upair A (upair x x))"

lemma cons_elems [iff]: "y \<in> cons x A \<longleftrightarrow> y = x \<or> y \<in> A"
  by (auto simp: cons_def upair_def)

lemma cons_induct:
  assumes "P a" and "\<And>x. x \<in> A \<Longrightarrow> P x"
  shows "\<And>x. x \<in> cons a A \<Longrightarrow> P x"
  using assms by auto

lemma consI1 [simp]: "a \<in> cons a A"
  by simp

lemma consI2: "a \<in> A \<Longrightarrow> a \<in> cons b A"
  by simp

lemma consE [elim]: "\<lbrakk>a \<in> cons b A; a = b \<Longrightarrow> P; a \<in> A \<Longrightarrow> P\<rbrakk> \<Longrightarrow> P"
  by auto

(*LP: Stronger version of the rule above*)
lemma consE':
  "\<lbrakk>a \<in> cons b A; a = b \<Longrightarrow> P; \<lbrakk>a \<in> A; a \<noteq> b\<rbrakk> \<Longrightarrow> P\<rbrakk> \<Longrightarrow> P"
  by auto

(*LP: Classical introduction rule*)
lemma consCI [intro!]: "(a \<notin> B \<Longrightarrow> a = b) \<Longrightarrow> a \<in> cons b B"
  by auto

lemma cons_not_empty [simp]: "cons a B \<noteq> {}"
  by auto

declare cons_not_empty [THEN not_sym, simp]

lemmas cons_ne_empty = cons_not_empty [THEN notE]

(*TODO: [simp]?*)
lemma cons_commute: "cons x (cons y A) = cons y (cons x A)"
  by (rule extensionality) auto

lemma cons_repeat: "cons x (cons x A) = cons x A"
  by (rule extensionality) auto

syntax
  "_finset" :: \<open>args \<Rightarrow> set\<close> ("{(_)}")
translations
  "{x, xs}" \<rightleftharpoons> "CONST cons x {xs}"
  "{x}" \<rightleftharpoons> "CONST cons x {}"

(*TODO: proper rewrite rules for finite sets!*)

lemma singleton_eq_iff [iff]: "{a} = {b} \<longleftrightarrow> a = b"
  by (auto dest: equalityD)

lemma singleton_mem_iff: "x \<in> {a} \<longleftrightarrow> x = a" by auto

lemma singleton_memD: "x \<in> {a} \<Longrightarrow> x = a" by auto
lemma singleton_memI: "a \<in> {a}" by auto

lemma singleton_dup: "{a} = {a, a}" by (rule extensionality) auto

lemma powerset_singleton: "powerset {a} = {{}, {a}}"
  by (rule extensionality) (auto intro: equalityI')

corollary powerset_singleton_elems [iff]: "x \<in> powerset {a} \<longleftrightarrow> x = {} \<or> x = {a}"
  using powerset_singleton by auto

corollary subset_singleton_elems [iff]: "x \<subseteq> {a} \<longleftrightarrow> x = {} \<or> x = {a}"
  using powerset_singleton_elems by auto

lemma pair_elems: "x \<in> {a, b} \<longleftrightarrow> x = a \<or> x = b"
  by auto

lemma pair_eq_iff: "{a, b} = {c, d} \<longleftrightarrow> (a = c \<and> b = d) \<or> (a = d \<and> b = c)"
  by (auto intro: equalityI' dest: equalityD)

lemma pair_cases:
  assumes "x \<in> {a, b}"
  obtains "x = a" | "x = b"
  using assms by (auto iff: pair_elems)

text \<open>
\<^term>\<open>upair x y\<close> and \<^term>\<open>{x, y}\<close> are equal, and thus interchangeable in
developments.
\<close>

lemma upair_eq_pair: "upair x y = {x, y}"
  unfolding upair_def
  by (rule equalityI) auto

lemmas pair_eq_upair = upair_eq_pair[symmetric]


section \<open>Restricted comprehension\<close>

definition collect :: \<open>set \<Rightarrow> (set \<Rightarrow> bool) \<Rightarrow> set\<close>
  where "collect A P \<equiv> \<Union>{if P x then {x} else {} | x \<in> A}"

syntax
  "_collect." :: \<open>pttrn \<Rightarrow> set \<Rightarrow> (set \<Rightarrow> bool) \<Rightarrow> set\<close> ("(1{_ \<in> _ ./ _})")
  "_collect|" :: \<open>pttrn \<Rightarrow> set \<Rightarrow> (set \<Rightarrow> bool) \<Rightarrow> set\<close> ("(1{_ \<in> _ |/ _})")
translations
  "{x \<in> A . P}" \<rightharpoonup> "CONST collect A (\<lambda>x. P)"
  "{x \<in> A | P}" \<rightleftharpoons> "CONST collect A (\<lambda>x. P)"

lemma collect_iff [iff]: "x \<in> {y \<in> A. P y} \<longleftrightarrow> x \<in> A \<and> P x"
  by (auto simp: collect_def)

lemma collectI [intro]: "\<lbrakk>x \<in> A; P x\<rbrakk> \<Longrightarrow> x \<in> {y \<in> A | P y}"
  by auto

lemma collectD1: "x \<in> {y \<in> A | P y} \<Longrightarrow> x \<in> A"
  by auto

lemma collectD2: "x \<in> {y \<in> A | P y} \<Longrightarrow> P x"
  by auto

lemma collect_subset: "collect A P \<subseteq> A"
  by blast

lemma collect_cong [cong]:
  "A = B \<Longrightarrow> (\<And>x. x \<in> B \<Longrightarrow> P x = Q x) \<Longrightarrow> collect A P = collect B Q"
  by (simp add: collect_def)

lemma collect_collect_eq [simp]:
  "collect (collect A P) Q = collect A (\<lambda>x. P x \<and> Q x)"
  by (rule extensionality) auto

lemma collect_cons:
  "{x \<in> cons a B. P x} = (if P a then cons a {x \<in> B. P x} else {x \<in> B. P x})"
  by (rule extensionality) auto

lemma collect_mono: "A \<subseteq> B \<Longrightarrow> collect A P \<subseteq> collect B P"
  by auto


section \<open>More replacement\<close>

lemma repl_singleton [simp]: "{f x | x \<in> {a}} = {f a}"
  by (rule equalityI) auto

lemma repl_cons: "{f x | x \<in> cons x A} = cons (f x) {f x | x \<in> A}"
  by (rule extensionality) auto

text \<open>
Replacement based on function-like predicates, as formulated in first-order
theories.
\<close>

definition replace :: \<open>set \<Rightarrow> (set \<Rightarrow> set \<Rightarrow> bool) \<Rightarrow> set\<close>
  where "replace A P = {THE y. P x y | x \<in> {x \<in> A | \<exists>!y. P x y}}"

syntax
  "_replace." :: \<open>[pttrn, pttrn, set, bool] => set\<close> ("(1{_ ./ _ \<in> _, _})")
  "_replace|" :: \<open>[pttrn, pttrn, set, bool] => set\<close> ("(1{_ |/ _ \<in> _, _})")
translations
  "{y . x \<in> A, Q}" \<rightharpoonup> "CONST replace A (\<lambda>x y. Q)"
  "{y | x \<in> A, Q}" \<rightleftharpoons> "CONST replace A (\<lambda>x y. Q)"

lemma replace_iff:
  "b \<in> {y | x \<in> A, P x y} \<longleftrightarrow> (\<exists>x \<in> A. P x b \<and> (\<forall>y. P x y \<longrightarrow> y = b))"
proof -
  have "b \<in> {y | x \<in> A, P x y} \<longleftrightarrow> (\<exists>x \<in> A. (\<exists>!y. P x y) \<and> b = (THE y. P x y))"
    using replace_def by auto
  also have "... \<longleftrightarrow> (\<exists>x \<in> A. P x b \<and> (\<forall>y. P x y \<longrightarrow> y = b))"
  proof (rule bex_cong[OF refl])
    fix x assume "x \<in> A"
    show
      "(\<exists>!y. P x y) \<and> b = (THE y. P x y) \<longleftrightarrow> P x b \<and> (\<forall>y. P x y \<longrightarrow> y = b)"
      (is "?lhs \<longleftrightarrow> ?rhs")
    proof
      assume "?lhs"
      then have ex1: "\<exists>!y. P x y" and b: "b = (THE y. P x y)" by auto
      show ?rhs
      proof
        from ex1 show "P x b" unfolding b by (rule theI')
        with ex1 show "\<forall>y. P x y \<longrightarrow> y = b" unfolding Ex1_def by blast
      qed
    next
      assume ?rhs
      then have P: "P x b" and uniq: "\<And>y. P x y \<Longrightarrow> y = b" by auto
      show ?lhs
      proof
        from P uniq
        show "\<exists>!y. P x y" by (rule ex1I)
        from this P
        show "b = (THE y. P x y)" by (rule the1_equality[symmetric])
      qed
    qed
  qed
  ultimately show ?thesis by auto
qed

(*Introduction; there must be a unique y such that P x y, namely y = b.*)
lemma replaceI [intro]:
  "\<lbrakk> P x b;  x \<in> A;  \<And>y. P x y \<Longrightarrow> y = b \<rbrakk> \<Longrightarrow> b \<in> {y | x \<in> A, P x y}"
  by (rule replace_iff [THEN iffD2], blast)

(*Elimination; may assume there is a unique y such that P x y, namely y = b.*)
lemma replaceE:
  "\<lbrakk> b \<in> {y | x \<in> A, P x y};  \<And>x. \<lbrakk>x \<in> A; P x b; \<forall>y. P x y \<longrightarrow> y = b\<rbrakk> \<Longrightarrow> R \<rbrakk> \<Longrightarrow> R"
  by (rule replace_iff [THEN iffD1, THEN bexE], simp+)

(*As above but without the (generally useless) third assumption*)
lemma replaceE2 [elim!]:
  "\<lbrakk>b \<in> {y. x \<in> A, P x y}; \<And>x. \<lbrakk>x \<in> A; P x b\<rbrakk> \<Longrightarrow> R\<rbrakk> \<Longrightarrow> R"
  by (erule replaceE, blast)

lemma replace_cong [cong]:
  "\<lbrakk>A = B; \<And>x y. x \<in> B \<Longrightarrow> P x y \<longleftrightarrow> Q x y\<rbrakk> \<Longrightarrow> replace A P = replace B Q"
  by (rule equalityI') (simp add: replace_iff)


section \<open>Set union and intersection\<close>

definition inter :: \<open>set => set\<close> ("\<Inter>_" [90] 90)
  where "\<Inter>A \<equiv> {x \<in> \<Union>A . \<forall>y \<in> A. x \<in> y}"

lemma union_empty [simp]: "\<Union>{} = {}"
  by auto

lemma inter_empty [simp]: "\<Inter>{} = {}"
  unfolding inter_def by auto

lemma union_subset_iff: "\<Union>A \<subseteq> C \<longleftrightarrow> (\<forall>x \<in> A. x \<subseteq> C)"
  by blast

lemma union_upper: "B \<in> A \<Longrightarrow> B \<subseteq> \<Union>A"
  by blast

lemma union_least: "(\<And>x. x \<in> A \<Longrightarrow> x \<subseteq> C) \<Longrightarrow> \<Union>A \<subseteq> C"
  by blast

text \<open>Indexed union and intersection:\<close>

syntax
  "_idxunion" :: \<open>[pttrn, set, set] => set\<close> ("(3\<Union>_\<in> _./ _)" [0, 0, 10] 10)
  "_idxinter" :: \<open>[pttrn, set, set] => set\<close> ("(3\<Inter>_\<in> _./ _)" [0, 0, 10] 10)
translations
  "\<Union>x\<in> A. B" \<rightleftharpoons> "\<Union>{B. x \<in> A}"
  "\<Inter>x\<in> A. B" \<rightleftharpoons> "\<Inter>{B. x \<in> A}"

lemma idxunion_iff [iff]: "b \<in> (\<Union>x\<in> A. (B x)) \<longleftrightarrow> (\<exists>x \<in> A. b \<in> B x)"
  by (simp add: bex_def) blast

(*LP: The order of the premises presupposes that A is rigid; b may be flexible*)
lemma idxunionI [intro]: "a \<in> A \<Longrightarrow>  b \<in> B a \<Longrightarrow> b \<in> (\<Union>x\<in> A. B x)"
  by (simp, blast)

lemma idxunionE [elim]: "\<lbrakk>b \<in> (\<Union>x\<in> A. B x); \<And>x. \<lbrakk>x \<in> A; b \<in> B x\<rbrakk> \<Longrightarrow> R\<rbrakk> \<Longrightarrow> R"
  by blast

lemma idxunion_cong:
  "\<lbrakk>A = B; \<And>x. x \<in> B \<Longrightarrow> C x = D x\<rbrakk> \<Longrightarrow> (\<Union>x\<in> A. C x) = (\<Union>x\<in> B. D x)"
  by simp

lemma idxunion_const: "A \<noteq> {} \<Longrightarrow> (\<Union>x\<in> A. B) = B"
  by (rule extensionality) auto

lemma idxunion_empty_family: "(\<Union>x\<in> {}. B) = {}"
  by auto

lemma idxunion_empty_sets: "(\<Union>x\<in> A. {}) = {}"
  by auto

lemma inter_iff [iff]: "A \<in> \<Inter>C \<longleftrightarrow> (\<forall>x \<in> C. A \<in> x) \<and> C \<noteq> {}"
  unfolding inter_def ball_def
  by (auto elim: not_emptyE)

lemma idxunion_subset_iff: "(\<Union>x\<in>A. B x) \<subseteq> C \<longleftrightarrow> (\<forall>x \<in> A. B x \<subseteq> C)"
by blast

lemma idxunion_upper: "x \<in> A \<Longrightarrow> B x \<subseteq> (\<Union>x\<in> A. B x)"
  by blast

lemma idxunion_least: "(\<And>x. x \<in> A \<Longrightarrow> B x \<subseteq> C) \<Longrightarrow> (\<Union>x\<in>A. B x) \<subseteq> C"
  by blast

lemma union_as_idxunion: "\<Union>A = (\<Union>x\<in> A. x)"
  by auto

lemma union_empty_iff [simp]: "\<Union>A = {} \<longleftrightarrow> A = {} \<or> A = {{}}"
proof
  assume "\<Union>A = {}" show "A = {} \<or> A = {{}}"
  proof (rule disjCI2)
    assume "A \<noteq> {}" then obtain x where "x \<in> A" by auto
    from \<open>\<Union>A = {}\<close> have [simp]: "\<And>x. x \<in> A \<Longrightarrow> x = {}" by auto
    with \<open>x \<in> A\<close> have "x = {}" by simp
    with \<open>x \<in> A\<close> have [simp]: "{} \<in> A" by simp
    show "A = {{}}" by (rule equalityI) auto
  qed
qed auto

lemma inter_as_idxinter: "\<Inter>A = (\<Inter>x \<in> A. x)"
  by auto

lemma inter_subset_iff: "A \<noteq> {} \<Longrightarrow> C \<subseteq> \<Inter>A \<longleftrightarrow> (\<forall>x \<in> A. C \<subseteq> x)"
  by blast

lemma inter_lower: "B \<in> A \<Longrightarrow> \<Inter>A \<subseteq> B"
  by blast

lemma inter_greatest: "\<lbrakk>A \<noteq> {}; \<And>x. x \<in> A \<Longrightarrow> C \<subseteq> x\<rbrakk> \<Longrightarrow> C \<subseteq> \<Inter>A"
  by blast

lemma idxinter_lower: "x \<in> A \<Longrightarrow> (\<Inter>x \<in> A. B x) \<subseteq> B x"
  by blast

lemma idxinter_greatest: "\<lbrakk>A \<noteq> {}; \<And>x. x \<in> A \<Longrightarrow> C \<subseteq> B x\<rbrakk> \<Longrightarrow> C \<subseteq> (\<Inter>x \<in> A. B x)"
  by auto

lemma union_singleton: "\<Union>{b} = b"
  by (rule extensionality) auto

lemma inter_singleton: "\<Inter>{b} = b"
  by (rule extensionality) auto

lemma idxunion_empty [simp]: "(\<Union>i \<in> {}. A i) = {}"
  by blast

lemma idxunion_singleton: "(\<Union>x\<in>A. {x}) = A"
  by (rule extensionality) auto

lemma flatten_idxunion [simp]:
  "(\<Union>x\<in> (\<Union>y \<in> A. B y). C x) = (\<Union>y \<in> A. \<Union>x\<in> B y. C x)"
  by (rule extensionality) auto

lemma idxunion_constant [simp]:
  "(\<Union>y \<in> A. c) = (if A = {} then {} else c)"
  by (rule extensionality) auto

lemma idxinter_constant [simp]:
  "(\<Inter>y \<in> A. c) = (if A = {} then {} else c)"
  by (rule extensionality) auto

lemma idxunion_repl [simp]:
  "(\<Union>y \<in> repl A f. B y) = (\<Union>x\<in> A. B (f x))"
  by auto

lemma idxinter_repl [simp]:
  "(\<Inter>x \<in> repl A f. B x) = (\<Inter>a \<in> A. B(f a))"
  by (auto simp add: inter_def)

lemma idxinter_union_eq:
  "{} \<notin> A \<Longrightarrow> (\<Inter>x \<in> \<Union>A. B x) = (\<Inter>y \<in> A. \<Inter>x \<in> y. B x)"
  by (rule equalityI) auto

lemma inter_idxunion_eq:
  assumes "\<forall>x \<in> A. B x \<noteq> {}"
  shows "(\<Inter>z \<in> (\<Union>x\<in>A. B x). C z) = (\<Inter>x \<in> A. \<Inter>z \<in> B x. C z)"
proof (rule equalityI)
  fix x assume "x \<in> (\<Inter>z \<in> (\<Union>x\<in> A. B x). C z)"
  with assms show "x \<in> (\<Inter>x\<in>A. \<Inter>z\<in> B x. C z)" by auto
next
  fix x assume *: "x \<in> (\<Inter>x \<in> A. \<Inter>z \<in> B x. C z)"
  then have "A \<noteq> {}" by auto
  then obtain y where "y \<in> A" by auto
  with assms have "B y \<noteq> {}" by auto
  with \<open>y\<in>A\<close> have "{B x | x \<in> A} \<noteq> {{}}" by (auto dest: equalityD)
  with * show "x \<in> (\<Inter>z \<in> (\<Union>x\<in> A. B x). C z)" by auto
qed

text \<open>Intersection is well-behaved only if the family is non-empty!\<close>

lemma interI [intro!]: "\<lbrakk>\<And>x. x \<in> C \<Longrightarrow> A \<in> x; C \<noteq> {}\<rbrakk> \<Longrightarrow> A \<in> \<Inter>C"
  by auto

(*LP: A "destruct" rule: every B in C contains A as an element, but A \<in> B can
  hold when B \<in> C does not! This rule is analogous to "spec".*)
lemma interD [elim, Pure.elim]: "\<lbrakk>A \<in> \<Inter>C; B \<in> C\<rbrakk> \<Longrightarrow> A \<in> B"
  by auto

(*LP: "Classical" elimination rule - does not require exhibiting "B \<in> C"*)
lemma interE [elim]: "\<lbrakk>A \<in> \<Inter>C; B \<notin> C \<Longrightarrow> R; A \<in> B \<Longrightarrow> R\<rbrakk> \<Longrightarrow> R"
  by auto

lemma idxinter_iff: "b \<in> (\<Inter>x \<in> A. B x) \<longleftrightarrow> (\<forall>x \<in> A. b \<in> B x) \<and> A \<noteq> {}"
  by auto
  
lemma idxinterI: "\<lbrakk>\<And>x. x \<in> A \<Longrightarrow> b \<in> B x; A \<noteq> {}\<rbrakk> \<Longrightarrow> b \<in> (\<Inter>x \<in> A. B x)"
  by blast

lemma idxinterE: "\<lbrakk>b \<in> (\<Inter>x \<in> A. B x); a \<in> A\<rbrakk> \<Longrightarrow> b \<in> B a"
  by blast

lemma idxinter_cong:
  "A = B \<Longrightarrow> (\<And>x. x \<in> B \<Longrightarrow> C x = D x) \<Longrightarrow> (\<Inter>x \<in> A. C x) = (\<Inter>x \<in> B. D x)"
  by simp


section \<open>Binary union and intersection\<close>

definition bin_union :: \<open>[set, set] \<Rightarrow> set\<close> (infixl "\<union>" 70)
  where "A \<union> B = \<Union>{A, B}"

definition bin_inter :: \<open>[set, set] \<Rightarrow> set\<close> (infixl "\<inter>" 70)
  where "A \<inter> B \<equiv> \<Inter>{A, B}"

lemma bin_union_iff [simp]: "x \<in> A \<union> B \<longleftrightarrow> x \<in> A \<or> x \<in> B"
  unfolding bin_union_def by auto

lemma bin_inter_iff [simp]: "x \<in> A \<inter> B \<longleftrightarrow> x \<in> A \<and> x \<in> B"
  unfolding bin_inter_def by auto

lemma bin_unionI1 [elim?]: "c \<in> A \<Longrightarrow> c \<in> A \<union> B"
  by simp

lemma bin_unionI2 [elim?]: "c \<in> B \<Longrightarrow> c \<in> A \<union> B"
  by simp

lemma bin_unionE [elim!]: "\<lbrakk>c \<in> A \<union> B; c \<in> A \<Longrightarrow> P; c \<in> B \<Longrightarrow> P\<rbrakk> \<Longrightarrow> P"
  by auto

(*LP: Stronger version of the rule above*)
lemma bin_unionE': "\<lbrakk>c \<in> A \<union> B; c \<in> A \<Longrightarrow> P; \<lbrakk>c \<in> B; c \<notin> A\<rbrakk> \<Longrightarrow> P\<rbrakk> \<Longrightarrow> P"
  by auto

(*LP: Classical introduction rule: no commitment to A vs B*)
lemma bin_unionCI [intro!]: "(c \<notin> B \<Longrightarrow> c \<in> A) \<Longrightarrow> c \<in> A \<union> B"
  by auto

lemma bin_union_commute: "A \<union> B = B \<union> A"
  by (rule extensionality) auto

lemma bin_union_left_commute: "A \<union> (B \<union> C) = B \<union> (A \<union> C)"
  by (rule extensionality) auto

lemma empty_bin_union_conv [simp]: "{} \<union> A = A"
  by (rule extensionality) auto

lemma bin_union_empty_conv [simp]: "A \<union> {} = A"
  by (rule extensionality) auto

lemma bin_union_singleton_absorb [simp]: "a \<in> A \<Longrightarrow> {a} \<union> A = A"
  by (rule equalityI) auto

lemma bin_union_subset_iff: "A \<union> B \<subseteq> C \<longleftrightarrow> A \<subseteq> C \<and> B \<subseteq> C"
  by blast

lemma bin_union_upper1: "A \<subseteq> A \<union> B"
  by blast

lemma bin_union_upper2: "B \<subseteq> A \<union> B"
  by blast

lemma bin_union_least: "\<lbrakk>A \<subseteq> C; B \<subseteq> C\<rbrakk> \<Longrightarrow> A \<union> B \<subseteq> C"
  by blast

lemma bin_union_absorb [simp]: "A \<union> A = A"
  by (rule extensionality) auto

lemma bin_union_left_absorb: "A \<union> (A \<union> B) = A \<union> B"
  by (rule extensionality) auto

lemma bin_union_assoc: "(A \<union> B) \<union> C  =  A \<union> (B \<union> C)"
  by (rule extensionality) auto

(*Binary union is an AC-operator*)
lemmas bin_union_ac =
  bin_union_assoc bin_union_left_absorb bin_union_commute bin_union_left_commute

lemma bin_union_subset_absorb1: "A \<subseteq> B \<Longrightarrow> A \<union> B = B"
  by (rule extensionality) auto

lemma bin_union_subset_absorb2: "B \<subseteq> A \<Longrightarrow> A \<union> B = A"
  by (rule extensionality) auto

lemma bin_union_bin_inter_distrib: "(A \<inter> B) \<union> C  =  (A \<union> C) \<inter> (B \<union> C)"
  by (rule extensionality) auto

lemma subset_bin_union_iff: "A \<subseteq> B \<longleftrightarrow> A \<union> B = B"
  by (auto intro: equalityI' dest: equalityD)

lemma subset_bin_union_iff2: "A \<subseteq> B \<longleftrightarrow> B \<union> A = B"
  by (auto intro: equalityI' dest: equalityD)

lemma bin_union_empty [iff]: "(A \<union> B = {}) \<longleftrightarrow> (A = {} \<and> B = {})"
  by blast

lemma bin_interI [intro!]: "\<lbrakk>c \<in> A; c \<in> B\<rbrakk> \<Longrightarrow> c \<in> A \<inter> B"
  by simp

lemma bin_interD1: "c \<in> A \<inter> B \<Longrightarrow> c \<in> A"
  by simp

lemma bin_interD2: "c \<in> A \<inter> B \<Longrightarrow> c \<in> B"
  by simp

lemma bin_interE [elim!]: "\<lbrakk>c \<in> A \<inter> B; \<lbrakk>c \<in> A; c \<in> B\<rbrakk> \<Longrightarrow> P\<rbrakk> \<Longrightarrow> P"
  by simp

lemma bin_inter_empty_iff [iff]: "(\<forall>a \<in> A. a \<notin> B) \<longleftrightarrow> A \<inter> B = {}"
  by auto

lemma bin_inter_commute [simp]: "A \<inter> B = B \<inter> A"
  by (rule extensionality) auto

lemma bin_inter_subset_iff [simp]: "C \<subseteq> A \<inter> B \<longleftrightarrow> C \<subseteq> A \<and> C \<subseteq> B"
  by blast

lemma bin_inter_lower1: "A \<inter> B \<subseteq> A"
  by blast

lemma bin_inter_lower2: "A \<inter> B \<subseteq> B"
  by blast

lemma bin_inter_greatest: "\<lbrakk>C \<subseteq> A; C \<subseteq> B\<rbrakk> \<Longrightarrow> C \<subseteq> A \<inter> B"
  by blast

lemma bin_inter_absorb [simp]: "A \<inter> A = A"
  by (rule extensionality) auto

lemma bin_inter_left_absorb [simp]: "A \<inter> (A \<inter> B) = A \<inter> B"
  by (rule extensionality) auto

lemma bin_inter_left_commute: "A \<inter> (B \<inter> C) = B \<inter> (A \<inter> C)"
  by (rule extensionality) auto

lemma bin_inter_assoc: "(A \<inter> B) \<inter> C  =  A \<inter> (B \<inter> C)"
  by (rule extensionality) auto

(*Binary intersection is an AC-operator*)
lemmas bin_inter_ac =
  bin_inter_assoc bin_inter_left_absorb bin_inter_commute bin_inter_left_commute

lemma bin_inter_subset_left_absorb: "B \<subseteq> A \<Longrightarrow> A \<inter> B = B"
  by (rule extensionality) auto

lemma bin_inter_subset_right_absorb: "A \<subseteq> B \<Longrightarrow> A \<inter> B = A"
  by (rule extensionality) auto

lemma bin_inter_bin_union_distrib: "A \<inter> (B \<union> C) = (A \<inter> B) \<union> (A \<inter> C)"
  by (rule extensionality) auto

lemma bin_inter_bin_union_distrib2: "(B \<union> C) \<inter> A = (B \<inter> A) \<union> (C \<inter> A)"
  by (rule extensionality) auto

lemma subset_bin_inter_iff: "A \<subseteq> B \<longleftrightarrow> A \<inter> B = A"
  by (auto intro: equalityI' dest: equalityD)

lemma subset_bin_inter_iff2: "A \<subseteq> B \<longleftrightarrow> B \<inter> A = A"
  by (auto intro: equalityI' dest: equalityD)

lemma bin_union_bin_inter_assoc_iff:
  "(A \<inter> B) \<union> C = A \<inter> (B \<union> C) \<longleftrightarrow> C \<subseteq> A"
  by (auto intro: equalityI' dest: equalityD)

lemma collect_bin_union:
  "{x \<in> A \<union> B | P x} = {x \<in> A | P x} \<union> {x \<in> B | P x}"
  by (rule extensionality) auto

lemma collect_bin_inter:
  "{x \<in> A \<inter> B | P x} = {x \<in> A | P x} \<inter> {x \<in> B | P x}"
  by (rule extensionality) auto

lemma bin_inter_collect_absorb:
  "A \<inter> {x \<in> A | P x} = {x \<in> A | P x}"
  by (rule extensionality) auto

lemma collect_idxunion_eq [simp]:
  "collect (\<Union>x\<in> A. B x) P = (\<Union>x\<in> A. collect (B x) P)"
  by (rule extensionality) auto

lemma bin_inter_collect_left:
  "{x \<in> A. P x} \<inter> B = {x \<in> A \<inter> B. P x}"
  by (rule extensionality) auto

lemma bin_inter_collect_right:
  "A \<inter> {x \<in> B. P x} = {x \<in> A \<inter> B. P x}"
  by (rule extensionality) auto

lemma collect_conj_eq:
  "{x \<in> A | P(x) \<and> Q(x)} = {x \<in> A | P x} \<inter> {x \<in> A | Q x}" 
  by (rule extensionality) auto

lemma collect_disj_eq:
  "{x \<in> A | P(x) \<or> Q(x)} = {x \<in> A | P x} \<union> {x \<in> A | Q x}"
  by (rule extensionality) auto

lemma subset_idxunion_iff_eq: "A \<subseteq> (\<Union>i \<in> I. B i) \<longleftrightarrow> A = (\<Union>i \<in> I. A \<inter> B i)"
  apply (rule iffI)
  apply (rule extensionality)
  apply (auto dest: equalityD)
  done

lemma union_bin_union_distrib: "\<Union>(A \<union> B) = \<Union>A \<union> \<Union>B"
  by (rule extensionality) auto

lemma union_bin_inter_subset: "\<Union>(A \<inter> B) \<subseteq> \<Union>A \<inter> \<Union>B"
  by blast

lemma union__disjoint_iff:
  "\<Union>C \<inter> A = {} \<longleftrightarrow> (\<forall>B \<in> C. B \<inter> A = {})"
  by (blast elim!: equalityE)

lemma union_empty_iff2: "\<Union>A = {} \<longleftrightarrow> (\<forall>B \<in> A. B = {})"
  by blast

lemma bin_inter_union_eq: "\<Union>B \<inter> A = (\<Union>C \<in> B. C \<inter> A)"
  by (rule extensionality) auto

lemma bin_union_inter_subset:
  "\<lbrakk>z \<in> A; z \<in> B\<rbrakk> \<Longrightarrow> \<Inter>A \<union> \<Inter>B \<subseteq> \<Inter>(A \<inter> B)"
  by blast

lemma inter_bin_union_distrib:
  "\<lbrakk>A \<noteq> {}; B \<noteq> {}\<rbrakk> \<Longrightarrow> \<Inter>(A \<union> B) = \<Inter>A \<inter> \<Inter>B"
  by (rule extensionality) auto

lemma idxunion_bin_union:
  "(\<Union>i\<in> A \<union> B. C i) = (\<Union>i\<in> A. C i) \<union> (\<Union>i\<in> B. C i)"
  by (rule extensionality) auto

lemma idxinter_union:
  "(\<Inter>i\<in> I \<union> J. A i) = (
    if I = {} then \<Inter>j\<in> J. A j
    else if J = {} then \<Inter>i\<in> I. A i
    else (\<Inter>i\<in> I. A i) \<inter> (\<Inter>j\<in> J. A j))"
  by (rule extensionality) auto

(*Halmos, Naive Set Theory, page 35*)
lemma bin_inter_idxunion_distrib:
  "B \<inter> (\<Union>i\<in> I. A i) = (\<Union>i\<in> I. B \<inter> A i)"
  by (rule extensionality) auto

lemma bin_union_idxinter_distrib:
  "I \<noteq> {} \<Longrightarrow> B \<union> (\<Inter>i\<in> I. A i) = (\<Inter>i\<in> I. B \<union> A i)"
  by (rule extensionality) auto

lemma bin_inter_idxunion_distrib2:
  "(\<Union>i\<in> I. A i) \<inter> (\<Union>j\<in> J. B j) = (\<Union>i\<in> I. \<Union>j\<in> J. A i \<inter> B j)"
  by (rule extensionality) auto

lemma bin_union_idxinter_distrib2:
  "\<lbrakk>I \<noteq> {}; J \<noteq> {}\<rbrakk> \<Longrightarrow>
    (\<Inter>i\<in> I. A i) \<union> (\<Inter>j\<in> J. B j) = (\<Inter>i\<in> I. \<Inter>j\<in> J. A i \<union> B j)"
  by (rule extensionality) auto

lemma idxunion_bin_union_distrib:
  "(\<Union>i\<in> I. A i \<union> B i) = (\<Union>i\<in> I. A i) \<union> (\<Union>i\<in> I. B i)"
  by (rule extensionality) auto

lemma idxinter_bin_inter_distrib:
  "I \<noteq> {} \<Longrightarrow> (\<Inter>i\<in> I. A i \<inter> B i) = (\<Inter>i\<in> I. A i) \<inter> (\<Inter>i\<in> I. B i)"
  by (rule extensionality) auto

lemma idxunion_bin_inter_subset:
  "(\<Union>z\<in> I \<inter> J. A z) \<subseteq> (\<Union>z\<in> I. A z) \<inter> (\<Union>z\<in> J. A z)"
  by blast


section \<open>Set difference\<close>

definition diff :: \<open>[set, set] \<Rightarrow> set\<close>  (infixl "\<setminus>" 65)
  where "A \<setminus> B \<equiv> {x \<in> A | x \<notin> B}"

lemma diff_iff [simp]: "c \<in> A \<setminus> B \<longleftrightarrow> (c \<in> A \<and> c \<notin> B)"
  unfolding diff_def by auto

lemma diffI [intro!]: "\<lbrakk>a \<in> A; a \<notin> B\<rbrakk> \<Longrightarrow> a \<in> A \<setminus> B"
  by simp

lemma diffD1: "a \<in> A \<setminus> B \<Longrightarrow> a \<in> A"
  by simp

lemma diffD2: "a \<in> A \<setminus> B \<Longrightarrow> a \<notin> B"
  by simp

lemma diffE [elim!]: "\<lbrakk>a \<in> A \<setminus> B; \<lbrakk>a \<in> A; a \<notin> B\<rbrakk> \<Longrightarrow> P\<rbrakk> \<Longrightarrow> P"
  by simp

lemma diff_subset: "A \<setminus> B \<subseteq> A"
  by blast

lemma diff_contains: "C \<subseteq> A \<Longrightarrow> C \<inter> B = {} \<Longrightarrow> C \<subseteq> A \<setminus> B"
  by blast

lemma diff_cancel: "A \<setminus> A = {}"
  by blast

lemma diff_triv: "A \<inter> B = {} \<Longrightarrow> A \<setminus> B = A"
  by (rule extensionality) auto

lemma empty_diff [simp]: "{} \<setminus> A = {}"
  by blast

lemma diff_empty [simp]: "A \<setminus> {} = A"
  by (rule extensionality) auto

lemma diff_eq_empty_iff: "A \<setminus> B = {} \<longleftrightarrow> A \<subseteq> B"
  by auto

lemma diff_disjoint: "A \<inter> (B \<setminus> A) = {}"
  by blast

lemma diff_partition: "A \<subseteq> B \<Longrightarrow> A \<union> (B \<setminus> A) = B"
  by (rule extensionality) auto

lemma diff_partition': "A \<union> (B \<setminus> A) = A \<union> B"
  by (rule extensionality) auto

lemma subset_bin_union_diff: "A \<subseteq> B \<union> (A \<setminus> B)"
  by blast

lemma double_complement: "A \<subseteq> B \<Longrightarrow> B \<subseteq> C \<Longrightarrow> B \<setminus> (C \<setminus> A) = A"
  by (rule extensionality) auto

lemma double_complement_bin_union: "(A \<union> B) \<setminus> (B \<setminus> A) = A"
  by (rule extensionality) auto

lemma bin_union_bin_inter_dist3:
 "(A \<inter> B) \<union> (B \<inter> C) \<union> (C \<inter> A) = (A \<union> B) \<inter> (B \<union> C) \<inter> (C \<union> A)"
  by (rule extensionality) auto

lemma diff_bin_union: "A \<setminus> (B \<union> C) = (A \<setminus> B) \<inter> (A \<setminus> C)"
  by (rule extensionality) auto

lemma diff_bin_inter: "A \<setminus> (B \<inter> C) = (A \<setminus> B) \<union> (A \<setminus> C)"
  by (rule extensionality) auto

lemma bin_union_diff: "(A \<union> B) \<setminus> C = (A \<setminus> C) \<union> (B \<setminus> C)"
  by (rule extensionality) auto

lemma bin_inter_diff: "(A \<inter> B) \<setminus> C = A \<inter> (B \<setminus> C)"
  by (rule extensionality) auto

lemma bin_inter_diff_eq: "C \<subseteq> A \<Longrightarrow> ((A \<setminus> B) \<inter> C) = (C \<setminus> B)"
  by (rule extensionality) auto

lemma diff_bin_inter_distrib: "C \<inter> (A \<setminus> B) = (C \<inter> A) \<setminus> (C \<inter> B)"
  by (rule extensionality) auto

lemma diff_bin_inter_distrib2: "(A \<setminus> B) \<inter> C = (A \<inter> C) \<setminus> (B \<inter> C)"
  by (rule extensionality) auto

lemma diff_idxunion: "I \<noteq> {} \<Longrightarrow> B \<setminus> (\<Union>i\<in> I. A i) = (\<Inter>i\<in> I. B \<setminus> A i)"
  by (rule extensionality) auto

lemma diff_idxinter: "I \<noteq> {} \<Longrightarrow> B \<setminus> (\<Inter>i\<in> I. A i) = (\<Union>i\<in> I. B \<setminus> A i)"
  by (rule extensionality) auto

lemma collect_diff: "collect (A \<setminus> B) P = collect A P \<setminus> collect B P"
  by (rule extensionality) auto


section \<open>\<in>-induction\<close>

lemma foundation: "X \<noteq> {} \<Longrightarrow> \<exists>Y \<in> X. Y \<inter> X = {}"
  using Axioms.mem_induction[of "\<lambda>x. x \<notin> X"] by auto

lemma foundation2: "X = {} \<or> (\<exists>Y \<in> X. \<forall>y \<in> Y. y \<notin> X)"
  using foundation by blast

lemma foundation3: "X \<noteq> {} \<Longrightarrow> \<exists>Y \<in> X. \<not>(\<exists>y \<in> Y. y \<in> X)"
proof -
  assume "X \<noteq> {}"
  with foundation obtain Y where "Y \<in> X" and "Y \<inter> X = {}" by blast
  thus "\<exists>Y \<in> X. \<not>(\<exists>y \<in> Y. y \<in> X)" by auto
qed

lemma empty_in_transitive_set:
  assumes "mem_transitive X"
      and "X \<noteq> {}"
  shows "{} \<in> X"
proof (rule ccontr)
  from foundation2 \<open>X \<noteq> {}\<close> obtain A where
    1: "A \<in> X" and
    2: "\<forall>a \<in> A. a \<notin> X"
    by force

  assume "{} \<notin> X" with 1 have "A \<noteq> {}" by auto
  then obtain a where
    3: "a \<in> A"
    by auto

  with \<open>mem_transitive X\<close> 1 have "a \<in> X"
    unfolding mem_transitive_def by auto
  thus False using 2 3 by auto
qed

lemma mem_asymE: "\<lbrakk>a \<in> b; \<not>P \<Longrightarrow> b \<in> a\<rbrakk> \<Longrightarrow> P"
  apply (rule classical)
  apply (rule_tac X1 = "{a,b}" in foundation2 [THEN disjE])
  apply (blast elim!: equalityE)+
  done

lemma mem_asym: "a \<in> b \<Longrightarrow> b \<notin> a"
  by (auto intro: mem_asymE)

lemma mem_irreflE: "a \<in> a \<Longrightarrow> P"
  by (blast intro: mem_asymE)

(*LP: @{thm mem_irreflE} should NOT be added to default databases: it would be
  tried on most goals, making proofs slower!*)

lemma mem_irrefl [simp]: "a \<notin> a"
  by (rule notI) (erule mem_irreflE)

(*LP: Good for proving inequalities by rewriting*)
lemma mem_imp_ne: "a \<in> A \<Longrightarrow> a \<noteq> A"
  by (blast elim: mem_irreflE)

lemma eq_imp_not_elem: "a = A \<Longrightarrow> a \<notin> A"
  by (blast elim: mem_irreflE)

lemma union_singletonE [elim]: "A = A \<union> {A} \<Longrightarrow> P"
  by (blast elim: equalityE mem_irreflE)

lemma mem_double_induct:
  assumes "\<And>X Y. \<lbrakk>\<And>x. x \<in> X \<Longrightarrow> P x Y; \<And>y. y \<in> Y \<Longrightarrow> P X y\<rbrakk> \<Longrightarrow> P X Y"
  shows "P X Y"
proof (induction X arbitrary: Y rule: mem_induction)
  fix X Y assume *: "\<And>x Y. x \<in> X \<Longrightarrow> P x Y"
  show "P X Y"
  proof (induction Y rule: mem_induction)
    fix Y assume "\<And>y. y \<in> Y \<Longrightarrow> P X y"
    with * show "P X Y" by (rule assms)
  qed
qed

lemma mem_3_cycle:
  assumes "a \<in> b" "b \<in> c" "c \<in> a"
  shows "False"
proof -
  let ?C = "{a, b, c}"
  have "?C \<noteq> {}" by simp
  from foundation[OF this]
  obtain Y where "Y \<in> ?C" "Y \<inter> ?C = {}" by auto
  from \<open>Y \<in> ?C\<close> have "Y = a \<or> Y = b \<or> Y = c" by simp
  thus ?thesis
  proof (elim disjE)
    assume "Y = a"
    with assms have "c \<in> Y \<inter> ?C" by auto
    with \<open>Y \<inter> ?C = {}\<close> show False by auto
  next
    assume "Y = b"
    with assms have "a \<in> Y \<inter> ?C" by auto
    with \<open>Y \<inter> ?C = {}\<close> show False by auto
  next
    assume "Y = c"
    with assms have "b \<in> Y \<inter> ?C" by auto
    with \<open>Y \<inter> ?C = {}\<close> show False by auto
  qed
qed


section \<open>More finite sets\<close>

lemma cons_ne_elem [simp]: "cons x A \<noteq> x"
  by (auto intro: consI1 mem_irreflE)

lemmas cons_ne_elem [symmetric, simp]

lemma bin_union_eq_cons: "{x} \<union> A = cons x A"
  by (rule extensionality) auto

lemmas bin_union_eq_cons' = bin_union_eq_cons[simplified bin_union_commute]


section \<open>Soft types\<close>

subsection \<open>Sets, elements and subsets\<close>

abbreviation Set :: "set type"
  where "Set \<equiv> Any"

definition empty :: "set \<Rightarrow> bool"
  where "empty A \<equiv> A = {}"

definition Element :: "set \<Rightarrow> set type"
  where [typedef]: "Element A \<equiv> type (\<lambda>x. x \<in> A)"

definition Subset :: "set \<Rightarrow> set type"
  where [typedef, type_simp]: "Subset A \<equiv> Element (powerset A)"

lemma Element_iff: "a \<in> A \<longleftrightarrow> a: Element A" by unfold_types

corollary
  ElementI: "a \<in> A \<Longrightarrow> a: Element A" and
  ElementD: "a: Element A \<Longrightarrow> a \<in> A"
  by (auto iff: Element_iff)

lemma Subset_iff: "A \<subseteq> B \<longleftrightarrow> A: Subset B" by unfold_types auto

lemma func_type_restrict_set_domain:
  assumes "A \<subseteq> B" "f : (b : Element B) \<Rightarrow> T b"
  shows "f : (a : Element A) \<Rightarrow> T a"
  (* Note Kevin: for some reason, the following loops: *)
  (* using assms by unfold_types auto) *)
  by (insert assms, unfold_types, auto)

lemma func_type_restrict_set_domain:
  assumes "A \<subseteq> B" "f : (b : Element B) \<Rightarrow> T b"
  shows "f : (a : Element A) \<Rightarrow> T a"
using assms by unfold_types auto

text \<open>Declare basic soft type translations.\<close>

corollary
  SubsetI: "A \<subseteq> B \<Longrightarrow> A: Subset B" and
  SubsetD: "A: Subset B \<Longrightarrow> A \<subseteq> B"
  by (auto iff: Subset_iff)

lemma subset_self [derive]: "A: Subset A"
  by unfold_types auto

text \<open>
Soft type translations let the typing automation prove set-theoretic statements.
\<close>

soft_type_translation
  "a \<in> A" \<rightleftharpoons> "a: Element A" by unfold_types

soft_type_translation
  "A \<subseteq> B" \<rightleftharpoons> "A: Subset B" by unfold_types auto

soft_type_translation
  "\<forall>x \<in> A. P x" \<rightleftharpoons> "\<forall>x: Element A. P x"
  by unfold_types auto

soft_type_translation
  "\<exists>x \<in> A. P x" \<rightleftharpoons> "\<exists>x: Element A. P x"
  by unfold_types auto

(* 
text \<open>
The following coercion allows us to use set constructions as if they were types.
\<close>
declare [[coercion_enabled, coercion Element]]
 *)

subsection \<open>Collections of sets\<close>

definition Collection :: "set type \<Rightarrow> set type"
  where [typeclass]: "Collection T \<equiv> type (\<lambda>x. \<forall>y \<in> x. y: T)"

lemma collection_element_imp_subset [derive]:
  "A: Collection (Element B) \<Longrightarrow> A: Subset B"
  by unfold_types blast

lemma subset_imp_collection_element [derive]:
  "A: Subset B \<Longrightarrow> A: Collection (Element B)"
  by unfold_types blast

subsection \<open>Basic constant types\<close>

text \<open>
The following typing rules are less general than what could be proved, since the
\<^term>\<open>Bool\<close> soft type is trivial. But the rules also determine the behavior of
type inference.

The rule for \<^term>\<open>HOL.All\<close> currently needs to be restricted due to a deficiency
in the elaboration algorithm.
\<close>

lemma
  [type]: "(\<in>): (Element A) \<Rightarrow> (Subset A) \<Rightarrow> Bool" and
  [type]: "powerset: Collection T \<Rightarrow> Collection (Collection T)" and
  [type]: "union: Collection (Collection T) \<Rightarrow> Collection T" and
  [type]: "repl: Collection T \<Rightarrow> (T \<Rightarrow> S) \<Rightarrow> Collection S" and

  [type]: "HOL.All: ((T::set type) \<Rightarrow> Bool) \<Rightarrow> Bool" and
  [type]: "{}: Subset A" and
  [type]: "(\<subseteq>): Subset A \<Rightarrow> Subset A \<Rightarrow> Bool" and
  [type]: "cons: Element A \<Rightarrow> Subset A \<Rightarrow> Subset A" and

  [type]: "(\<union>): Subset A \<Rightarrow> Subset A \<Rightarrow> Subset A" and
  [type]: "(\<inter>): Subset A \<Rightarrow> Subset A \<Rightarrow> Subset A" and
  [type]: "collect: Subset A \<Rightarrow> (Element A \<Rightarrow> Bool) \<Rightarrow> Subset A"

  by unfold_types auto

subsection \<open>Set theory and Pi types\<close>

lemma set_Pi_typeI [dest]: "\<forall>x. x \<in> A \<longrightarrow> f x \<in> B \<Longrightarrow> f: Element A \<Rightarrow> Element B"
  by unfold_types

lemma set_Pi_typeI' [dest]: "\<forall>x \<in> A. f x \<in> B \<Longrightarrow> f: Element A \<Rightarrow> Element B"
  by unfold_types auto


section \<open>Universes\<close>

abbreviation V :: set where "V \<equiv> univ {}"

lemma
  assumes "ZF_closed U" and "X \<in> U"
  shows
    ZF_closed_union: "\<Union>X \<in> U" and
    ZF_closed_powerset: "powerset X \<in> U" and
    ZF_closed_replacement: "(\<And>x. x \<in> X \<Longrightarrow> f x \<in> U) \<Longrightarrow> repl X f \<in> U"
  using assms by (auto simp: ZF_closed_def)

lemma
  assumes "A \<in> univ X"
  shows
    univ_union_closed [intro]: "\<Union>A \<in> univ X"
  and
    univ_powerset_closed [intro]: "powerset A \<in> univ X"
  and
    univ_replacement_closed [intro]:
      "(\<And>x. x \<in> A \<Longrightarrow> f x \<in> univ X) \<Longrightarrow> repl A f \<in> univ X"
  by (auto intro: assms
    univ_ZF_closed ZF_closed_union ZF_closed_powerset ZF_closed_replacement)

text \<open>Variations on transitivity:\<close>

lemma univ_transitive: "A \<in> univ X \<Longrightarrow> x \<in> A \<Longrightarrow> x \<in> univ X"
  using univ_trans[unfolded mem_transitive_def] by auto

lemma univ_transitive2: "A \<in> univ X \<Longrightarrow> A \<subseteq> univ X"
  using univ_transitive by auto

lemma univ_transitive3: "x \<in> X \<Longrightarrow> x \<in> univ X"
  using univ_transitive univ_elem by auto

lemma empty_in_univ [intro]: "{} \<in> univ X"
proof -
  have "X \<in> univ X" by (rule univ_elem)
  then have "powerset X \<subseteq> univ X" by (auto intro: univ_transitive)
  then show "{} \<in> univ X" by auto
qed

lemma univ_nonempty [intro]: "non-empty (univ X)"
  unfolding non_def empty_def by auto

lemma univ_subset [intro]: "A \<subseteq> univ A"
  by (auto intro: univ_transitive univ_elem)

lemma univ_upair_closed [intro]:
  "\<lbrakk>x \<in> univ X; y \<in> univ X\<rbrakk> \<Longrightarrow> upair x y \<in> univ X"
  unfolding upair_def by (rule univ_replacement_closed) auto

lemma univ_cons_closed [intro]:
  "x \<in> univ X \<Longrightarrow> A \<in> univ X \<Longrightarrow> cons x A \<in> univ X"
  unfolding cons_def by (intro univ_union_closed univ_upair_closed)

corollary univ_pair_closed [intro]:
  "\<lbrakk>x \<in> univ X; y \<in> univ X\<rbrakk> \<Longrightarrow> {x, y} \<in> univ X"
  by auto

lemma univ_bin_union_closed [intro]:
  "\<lbrakk>x \<in> univ X; y \<in> univ X\<rbrakk> \<Longrightarrow> x \<union> y \<in> univ X"
  unfolding bin_union_def by auto

lemma univ_singleton_closed [intro]:
  "x \<in> univ U \<Longrightarrow> {x} \<in> univ U"
  by auto

lemma univ_bin_union_left:
  "A \<in> univ U \<Longrightarrow> A \<union> univ U = univ U"
  by (rule extensionality) (auto intro: univ_transitive)

lemmas univ_bin_union_right = univ_bin_union_left[simplified bin_union_commute]


end