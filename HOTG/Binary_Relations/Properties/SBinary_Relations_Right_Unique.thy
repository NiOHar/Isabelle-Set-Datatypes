\<^marker>\<open>creator "Kevin Kappelmann"\<close>
subsubsection \<open>Right Unique\<close>
theory SBinary_Relations_Right_Unique
  imports
    SBinary_Relation_Functions
    Transport.Binary_Relations_Right_Unique
    ML_Unification.Unify_Fact_Tactic
begin

overloading
  right_unique_on_set \<equiv> "right_unique_on :: set \<Rightarrow> (set \<Rightarrow> 'a \<Rightarrow> bool) \<Rightarrow> bool"
  set_right_unique_on_pred \<equiv> "right_unique_on :: (set \<Rightarrow> bool) \<Rightarrow> set \<Rightarrow> bool"
  set_right_unique_on_set \<equiv> "right_unique_on :: set \<Rightarrow> set \<Rightarrow> bool"
begin
  definition "right_unique_on_set (A :: set) (R :: set \<Rightarrow> 'a \<Rightarrow> bool) \<equiv> right_unique_on (mem_of A) R"
  definition "set_right_unique_on_pred (P :: set \<Rightarrow> bool) (R :: set) \<equiv> right_unique_on P (rel R)"
  definition "set_right_unique_on_set (A :: set) (R :: set) \<equiv> right_unique_on (mem_of A) R"
end

lemma right_unique_on_set_eq_right_unique_on_pred [simp]:
  "(right_unique_on (S :: set) :: (set \<Rightarrow> 'a \<Rightarrow> bool) \<Rightarrow> bool) = right_unique_on (mem_of S)"
  unfolding right_unique_on_set_def by simp

lemma right_unique_on_set_eq_right_unique_on_pred_uhint [uhint]:
  assumes "P \<equiv> mem_of S"
  shows "right_unique_on (S :: set) :: (set \<Rightarrow> 'a \<Rightarrow> bool) \<Rightarrow> bool \<equiv> right_unique_on P"
  using assms by simp

lemma right_unique_on_set_iff_right_unique_on_pred [iff]:
  "right_unique_on (S :: set) (R :: set \<Rightarrow> 'a \<Rightarrow> bool) \<longleftrightarrow> right_unique_on (mem_of S) R"
  by simp

lemma set_right_unique_on_pred_iff_right_unique_on_pred [iff]:
  "right_unique_on (P :: set \<Rightarrow> bool) R \<longleftrightarrow> right_unique_on P (rel R)"
  unfolding set_right_unique_on_pred_def by simp

lemma set_right_unique_on_pred_iff_right_unique_on_pred_uhint [uhint]:
  assumes "R \<equiv> rel S"
  shows "right_unique_on (P :: set \<Rightarrow> bool) S \<equiv> right_unique_on P R"
  using assms by simp

lemma set_right_unique_on_set_eq_set_right_unique_on_pred [simp]:
  "(right_unique_on (S :: set) :: set \<Rightarrow> bool) = right_unique_on (mem_of S)"
  unfolding set_right_unique_on_set_def by simp

lemma set_right_unique_on_set_eq_set_right_unique_on_pred_uhint [uhint]:
  assumes "P \<equiv> mem_of S"
  shows "right_unique_on (S :: set) :: set \<Rightarrow> bool \<equiv> right_unique_on P"
  using assms by simp

lemma set_right_unique_on_set_iff_set_right_unique_on_pred [iff]:
  "right_unique_on (S :: set) (R :: set) \<longleftrightarrow> right_unique_on (mem_of S) R"
  by simp

lemma set_right_unique_on_compI:
  fixes P :: "set \<Rightarrow> bool" and R S :: "set"
  assumes "right_unique_on P R"
  and "right_unique_on (codom R\<restriction>\<^bsub>P\<^esub> \<inter> dom S) S"
  shows "right_unique_on P (set_rel_comp R S)"
  supply set_to_HOL_simp[simp] using assms by (urule right_unique_on_compI)

lemma right_unique_on_glueI:
  fixes P :: "set \<Rightarrow> bool"
  assumes "\<And>R R'. R \<in> \<R> \<Longrightarrow> R' \<in> \<R> \<Longrightarrow> right_unique_on P (glue {R, R'})"
  shows "right_unique_on P (glue \<R>)"
proof -
  {
    fix x y y' assume "P x" "\<langle>x, y\<rangle> \<in> glue \<R>" "\<langle>x, y'\<rangle> \<in> glue \<R>"
    with assms obtain R R' where "R \<in> \<R>" "R' \<in> \<R>" "\<langle>x, y\<rangle> \<in> R" "\<langle>x, y'\<rangle> \<in> R'"
      and runique: "right_unique_on P (glue {R, R'})"
      by auto
    then have "\<langle>x, y\<rangle> \<in> (glue {R, R'})" "\<langle>x, y'\<rangle> \<in> (glue {R, R'})" by auto
    with \<open>P x\<close> runique have "y = y'" by (auto dest: right_unique_onD)
  }
  then show ?thesis by blast
qed

overloading
  right_unique_at_set \<equiv> "right_unique_at :: set \<Rightarrow> ('a \<Rightarrow> set \<Rightarrow> bool) \<Rightarrow> bool"
  set_right_unique_at_pred \<equiv> "right_unique_at :: (set \<Rightarrow> bool) \<Rightarrow> set \<Rightarrow> bool"
  set_right_unique_at_set \<equiv> "right_unique_at :: set \<Rightarrow> set \<Rightarrow> bool"
begin
  definition "right_unique_at_set (A :: set) (R :: 'a \<Rightarrow> set \<Rightarrow> bool) \<equiv>
    right_unique_at (mem_of A) R"
  definition "set_right_unique_at_pred (P :: set \<Rightarrow> bool) (R :: set) \<equiv> right_unique_at P (rel R)"
  definition "set_right_unique_at_set (A :: set) (R :: set) \<equiv> right_unique_at (mem_of A) R"
end

lemma right_unique_at_set_eq_right_unique_at_pred [simp]:
  "(right_unique_at (S :: set) :: ('a \<Rightarrow> set \<Rightarrow> bool) \<Rightarrow> bool) = right_unique_at (mem_of S)"
  unfolding right_unique_at_set_def by simp

lemma right_unique_at_set_eq_right_unique_at_pred_uhint [uhint]:
  assumes "P \<equiv> mem_of S"
  shows "right_unique_at (S :: set) :: ('a \<Rightarrow> set \<Rightarrow> bool) \<Rightarrow> bool \<equiv> right_unique_at P"
  using assms by simp

lemma right_unique_at_set_iff_right_unique_at_pred [iff]:
  "right_unique_at (S :: set) (R :: set \<Rightarrow> set \<Rightarrow> bool) \<longleftrightarrow> right_unique_at (mem_of S) R"
  by simp

lemma set_right_unique_at_pred_iff_right_unique_at_pred [iff]:
  "right_unique_at (P :: set \<Rightarrow> bool) R \<longleftrightarrow> right_unique_at P (rel R)"
  unfolding set_right_unique_at_pred_def by simp

lemma set_right_unique_at_pred_iff_right_unique_at_pred_uhint [uhint]:
  assumes "R \<equiv> rel S"
  shows "right_unique_at (P :: set \<Rightarrow> bool) S \<equiv> right_unique_at P R"
  using assms by simp

lemma set_right_unique_at_set_eq_set_right_unique_at_pred [simp]:
  "(right_unique_at (S :: set) :: set \<Rightarrow> bool) = right_unique_at (mem_of S)"
  unfolding set_right_unique_at_set_def by simp

lemma set_right_unique_at_set_eq_set_right_unique_at_pred_uhint [uhint]:
  assumes "P \<equiv> mem_of S"
  shows "right_unique_at (S :: set) :: set \<Rightarrow> bool \<equiv> right_unique_at P"
  using assms by simp

lemma set_right_unique_at_set_iff_set_right_unique_at_pred [iff]:
  "right_unique_at (S :: set) (R :: set) \<longleftrightarrow> right_unique_at (mem_of S) R"
  by simp

end
