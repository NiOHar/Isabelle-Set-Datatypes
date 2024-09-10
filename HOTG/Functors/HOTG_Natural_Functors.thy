theory HOTG_Natural_Functors 
  imports HOTG_Lists HOTG_Functions_Composition
begin
term "{}`x"
term codom

unbundle no_HOL_groups_syntax no_HOL_order_syntax
(* vector_mono_wrt_pred *)

(*definition "vector_mono_wrt_pred vin vout =  zipWnth (\<Rightarrow>) vin vout"*)

definition "vector_mono_wrt_pred vin vout = undefined"

locale HOTG_Natural_Functor = 
  fixes F 
  and n :: set
  and Fmap
  and vFset
  assumes "n \<in> \<omega>"
  and Fmap_id: "\<And>U vT. vector U n vT \<Longrightarrow> Fmap (map set_id vT) = set_id (F vT)"
  and Fmap_comp: "\<And>vf vg U vin vmid vout. vector U n vf \<Longrightarrow> vector U n vg \<Longrightarrow> vector U n vin
  \<Longrightarrow> vector U n vmid \<Longrightarrow> vector U n vout
  \<Longrightarrow> (\<And>i.0 \<le> i \<Longrightarrow> i < n \<Longrightarrow> (nth i vin \<Rightarrow> nth i vmid) (nth i vf) \<and> (nth i vmid \<Rightarrow> nth i vout) (nth i vg)) \<Longrightarrow>
    Fmap (fun_vector_compose vg vf) = Fmap vg \<circ> Fmap vf"
  and Fmap_type: "\<And>U vin vout vf i. vector U n vin \<Longrightarrow> vector U n vout \<Longrightarrow> vector U n vf
   \<Longrightarrow> 0 \<le> i \<Longrightarrow> i < n \<Longrightarrow> (nth i vin \<Rightarrow> nth i vout) (nth i vf)
   \<Longrightarrow> (F vin \<Rightarrow> F vout) (Fmap vf)"
  and Fset_types:
    "\<And>U v i. vector U n v \<Longrightarrow> 0 \<le> i  \<Longrightarrow> i < n \<Longrightarrow> (F v \<Rightarrow> nth i v) (nth i vFset)"
  and Fmap_cong: "\<And>U vf vg x. vector U n vf \<Longrightarrow> vector U n vg \<Longrightarrow> 
  (\<And>i xi. 0 \<le> i \<Longrightarrow> i < n \<Longrightarrow>  xi \<in> (nth i (vFset))`x \<Longrightarrow> (nth i vf)`xi = (nth i vg)`xi)
  \<Longrightarrow> (Fmap vf)`x = (Fmap vg)`x"(* type vf vg x*)
  and FsetI_natural: "\<And>vf i x. 0 \<le> i \<Longrightarrow> i < n \<Longrightarrow> ((nth i vFset) \<circ> (Fmap vf))`x = {(nth i vf)`xi | xi \<in> (nth i vFset)`x}"
begin

definition "Fin U vA = {x \<in> U | \<forall>i. (nth i vFset)`x \<subseteq> (nth i vA)}"

lemma succ_pred_eq: "succ (pred n) = n" sorry

lemma fmap_comp_id: (*is this interesting? - it's just fmap comp wnth a concrete element in one vector?*)
  assumes "vector U (pred n) vf"
  and "vector U n vg"
  and "vector U n vin"
  and "vector U n vmid"
  and "vector U n vout"
  and "\<And>i. ((nth i vin \<Rightarrow> nth i vmid) (nth i (cons (set_id U) vf)) \<and> (nth i vmid \<Rightarrow> nth i vout) (nth i vg))"
shows "Fmap (fun_vector_compose vg (cons (set_id U) vf)) = (Fmap vg) \<circ>  (Fmap (cons (set_id U) vf))"
proof -
  have "set_id U \<in> U" sorry
  wnth assms(1) have "list U (cons (set_id U) vf)" unfolding vector_def using cons_type by auto
  wnth assms(1) have "length (cons (set_id U) vf) = n" using length_cons_eq_succ succ_pred_eq unfolding vector_def by auto
  wnth \<open>list U (cons (set_id U) vf)\<close> have "vector U n (cons (set_id U) vf)" unfolding vector_def by auto
  wnth assms Fmap_comp show ?thesis by auto
qed

definition  "alg U vB (s::set) = ((\<forall>x i. x \<in> Fin U vB \<longrightarrow> nth i (s`x) \<in> (nth i vB)))"

definition "mor U vB s vB' s' h \<equiv>
   alg U vB s \<and> alg U vB' s' \<and> ((\<forall>x. x \<in> Fin U vB \<longrightarrow> h`(s`x) = s'`((Fmap h)`x)))"

end

(*
typedecl ('d, 'a, 'b, 'c) F


consts Fmap :: "('a1 \<Rightarrow> 'a2) \<Rightarrow> ('b1 \<Rightarrow> 'b2) \<Rightarrow> ('c1 \<Rightarrow> 'c2) \<Rightarrow>
    ('d, 'a1, 'b1, 'c1) F \<Rightarrow> ('d, 'a2, 'b2, 'c2) F"
  Fset1 :: "('d, 'a, 'b, 'c) F \<Rightarrow> 'a set"
  Fset2 :: "('d, 'a, 'b, 'c) F \<Rightarrow> 'b set"
  Fset3 :: "('d, 'a, 'b, 'c) F \<Rightarrow> 'c set"

axiomatization
  where Fmap_id: "Fmap id id id = id"
  and Fmap_comp: "\<And>f1 f2 f3 g1 g2 g3.
    Fmap (g1 \<circ> f1) (g2 \<circ> f2) (g3 \<circ> f3) = Fmap g1 g2 g3 \<circ> Fmap f1 f2 f3"
  and Fmap_cong: "\<And>f1 f2 f3 g1 g2 g3 x.
    (\<And>x1. x1 \<in> Fset1 x \<Longrightarrow> f1 x1 = g1 x1) \<Longrightarrow>
    (\<And>x2. x2 \<in> Fset2 x \<Longrightarrow> f2 x2 = g2 x2) \<Longrightarrow>
    (\<And>x3. x3 \<in> Fset3 x \<Longrightarrow> f3 x3 = g3 x3) \<Longrightarrow>
    Fmap f1 f2 f3 x = Fmap g1 g2 g3 x"
  and Fset1_natural: "\<And>f1 f2 f3. Fset1 \<circ> Fmap f1 f2 f3 = image f1 \<circ> Fset1"
  and Fset2_natural: "\<And>f1 f2 f3. Fset2 \<circ> Fmap f1 f2 f3 = image f2 \<circ> Fset2"
  and Fset3_natural: "\<And>f1 f2 f3. Fset3 \<circ> Fmap f1 f2 f3 = image f3 \<circ> Fset3"
*)

end