section \<open>Universes\<close>

theory Universe
imports Ordinal

begin

subsection \<open>Closure properties\<close>

lemma ZF_closed_Union: "ZF_closed U \<Longrightarrow> X \<in> U \<Longrightarrow> \<Union>X \<in> U"
  unfolding ZF_closed_def by blast

lemma ZF_closed_Pow: "ZF_closed U \<Longrightarrow> X \<in> U \<Longrightarrow> Pow X \<in> U"
  unfolding ZF_closed_def by blast

lemma ZF_closed_Repl: "ZF_closed U \<Longrightarrow> X \<in> U \<Longrightarrow> (\<And>x. x \<in> X \<Longrightarrow> f x \<in> U) \<Longrightarrow> Repl X f \<in> U"
  unfolding ZF_closed_def by blast


lemma Univ_Union [intro]: "A \<in> Univ X \<Longrightarrow> \<Union>A \<in> Univ X"
  using Univ_ZF_closed by (rule ZF_closed_Union)

lemma Univ_Pow [intro]: "A \<in> Univ X \<Longrightarrow> Pow A \<in> Univ X"
  using Univ_ZF_closed by (rule ZF_closed_Pow)

lemma Univ_Repl [intro]:
  "A \<in> Univ X \<Longrightarrow> (\<And>x. x \<in> A \<Longrightarrow> f x \<in> Univ X) \<Longrightarrow> Repl A f \<in> Univ X"
  using Univ_ZF_closed by (rule ZF_closed_Repl)

(*
  Josh - could also write the following as a [type] registration on Union.
  Does it make any difference functionally? Help/hinder the type elaborator?
*)
lemma Univ_type_Union [derive]: "A : element (Univ X) \<Longrightarrow> \<Union>A : element (Univ X)"
  using Univ_Union by squash_types

lemma Univ_type_Pow [type]: "Pow : element (Univ X) \<Rightarrow> element (Univ X)"
  using Univ_Pow by squash_types auto

lemma Univ_type_Repl [derive, bderive]:
  "\<lbrakk> A : element (Univ X) ;  f : element A \<Rightarrow> element (Univ X) \<rbrakk>
    \<Longrightarrow> Repl A f : element (Univ X)"
  unfolding element_type_iff by squash_types auto

lemma Univ_element_closed: "A \<in> Univ X \<Longrightarrow> A \<subseteq> Univ X"
  using Univ_transitive[unfolded epsilon_transitive_def] by blast

lemma Univ_element_closed_type [derive]: "A : element (Univ X) \<Longrightarrow> A : subset (Univ X)"
  by squash_types (fact Univ_element_closed)

lemma Univ_element_closed_type' [derive]:
  "x : element A \<Longrightarrow> A : element (Univ X) \<Longrightarrow> x : element (Univ X)"
  using Univ_element_closed
  by squash_types auto

lemma Univ_element_closed_type'' [derive]:
  "x : element A \<Longrightarrow> A : subset (Univ X) \<Longrightarrow> x : element (Univ X)"
  using Univ_element_closed
  by squash_types auto

lemma Univ_empty [intro]: "{} \<in> Univ X"
proof -
  have "X \<in> Univ X" by (rule Univ_elem)
  then have "Pow X \<in> Univ X" by (rule Univ_Pow)
  then have "Pow X \<subseteq> Univ X" by (rule Univ_element_closed)
  then show "{} \<in> Univ X" by auto
qed

lemma Univ_type_empty [derive]: "{} : element (Univ X)"
  by squash_types (fact Univ_empty)

lemma Univ_base [derive]: "A : element (Univ A)"
  by squash_types (fact Univ_elem)

lemma Univ_subset: "A \<subseteq> Univ A"
  by (rule Univ_element_closed) (fact Univ_elem)

lemma Univ_type_subset [derive]: "A : subset (Univ A)"
  by squash_types (fact Univ_subset)

(* This one is problematic as a [derive] rule, since it can loop *)
lemma Univ_elem_type:
  "x : element A \<Longrightarrow> x : element (Univ A)"
  by (rule Univ_element_closed_type'[OF _ Univ_base])

lemma Univ_Upair [intro]: "x \<in> Univ X \<Longrightarrow> y \<in> Univ X \<Longrightarrow> Upair x y \<in> Univ X"
  unfolding Upair_def
  by (intro Univ_Repl Univ_Pow Univ_empty) auto

lemma Univ_type_Upair [derive]:
  "x : element (Univ X) \<Longrightarrow> y : element (Univ X) \<Longrightarrow> Upair x y : element (Univ X)"
  using Univ_Upair by squash_types

lemma Univ_Cons [intro]: "x \<in> Univ X \<Longrightarrow> A \<in> Univ X \<Longrightarrow> Cons x A \<in> Univ X"
  unfolding Cons_def
  by (intro Univ_Union Univ_Upair)

lemma Univ_type_Cons [derive]:
  "x : element (Univ X) \<Longrightarrow> A : element (Univ X) \<Longrightarrow> Cons x A : element (Univ X)"
  by squash_types auto

lemma Univ_Un [intro]: "x \<in> Univ X \<Longrightarrow> y \<in> Univ X \<Longrightarrow> x \<union> y \<in> Univ X"
  unfolding Un_def by auto

lemma Univ_type_Un [derive]:
  "A : element (Univ X) \<Longrightarrow> B : element (Univ X) \<Longrightarrow> A \<union> B : element (Univ X)"
  by squash_types auto

lemma Univ_Succ [intro]: "x \<in> Univ X \<Longrightarrow> Succ x \<in> Univ X"
  unfolding Succ_def by auto

lemma Univ_type_Succ [derive]: "x : element (Univ X) \<Longrightarrow> Succ x :  element (Univ X)"
  by squash_types auto


end
