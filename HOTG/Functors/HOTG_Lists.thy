theory HOTG_Lists
  imports HOTG_Functions_Monotone HOTG_Ordinals_Omega ML_Unification.Unification_Attributes
begin

axiomatization
  nil :: "set" 
  and cons :: "set \<Rightarrow> set \<Rightarrow> set"
  and list_rec :: "'a \<Rightarrow> (set \<Rightarrow> set \<Rightarrow> 'a \<Rightarrow> 'a) \<Rightarrow> set \<Rightarrow> 'a"
  and list :: "set \<Rightarrow> set \<Rightarrow> bool"
  where nil_ne_cons[iff]: "\<And>x xs. nil \<noteq> cons x xs"
  and cons_inj[iff]: "\<And>x xs y ys. cons x xs = cons y ys \<longleftrightarrow> (x = y \<and> xs = ys)"
  and nil_type: "\<And>A. (list A) nil"
  and cons_type: "\<And>A. (mem_of A \<Rightarrow> list A \<Rightarrow> list A) cons"
  and list_rec_nil: "\<And>n c. list_rec n c nil = n"
  and list_rec_cons: "\<And>n c x xs. list_rec n c (cons x xs) = c x xs (list_rec n c xs)"
  and list_rec_type: "\<And>(P :: 'a \<Rightarrow> bool) A. 
    (P \<Rightarrow> (mem_of A \<Rightarrow> list A \<Rightarrow> P \<Rightarrow> P) \<Rightarrow> list A \<Rightarrow> P) list_rec"
  and list_induct[case_names nil cons, induct type: set, consumes 1]: "\<And>A P xs. list A xs \<Longrightarrow> P nil \<Longrightarrow>
    (\<And>x xs. x \<in> A \<Longrightarrow> list A xs \<Longrightarrow> P xs \<Longrightarrow>  P (cons x xs)) \<Longrightarrow> P xs"

unbundle no_HOL_groups_syntax no_HOL_ascii_syntax no_HOL_order_syntax

lemma list_cons_imp:"list A (cons x xs) \<Longrightarrow> mem_of A x \<and> list A xs"
 by (induction "(cons x xs)" rule: list_induct) auto

definition "length \<equiv> list_rec 0 (\<lambda>_ _. succ)"

lemma length_nil_eq[simp]: "length nil = 0"
  unfolding length_def by (fact list_rec_nil)

lemma length_cons_eq_succ[simp]: "length (cons x xs) = succ (length xs)"
  unfolding length_def using list_rec_cons[of _ "\<lambda>_ _. succ"] by simp

lemma length_type: "(list A \<Rightarrow> mem_of \<omega>) length"
proof-
  have T1: "(mem_of A \<Rightarrow> list A \<Rightarrow> mem_of \<omega> \<Rightarrow> mem_of \<omega>) (\<lambda> _ _ . succ)" 
    using succ_mem_omega_if_mem by blast
  have T2: "mem_of \<omega> 0" by auto
  from list_rec_type[THEN mono_wrt_predD, THEN mono_wrt_predD, OF T2 T1]
  show ?thesis using list_rec_type unfolding length_def by blast
qed

definition "is_nil = list_rec True (\<lambda>_ _ _. False)"

lemma is_nil_nil[simp]: "is_nil nil"
  unfolding is_nil_def using list_rec_nil[of True] by blast

lemma not_is_nil_cons[simp]: "\<And>x xs. \<not>is_nil (cons x xs)"
  unfolding is_nil_def using list_rec_cons[of True "(\<lambda>_ _ _. False)"] by blast

definition "is_cons = list_rec False (\<lambda>_ _ _. True)"

lemma not_is_cons_nil[simp]: "\<not>is_cons nil"
  unfolding is_cons_def using list_rec_nil[of False] by blast

lemma is_cons_cons[simp]: "\<And>x xs. is_cons (cons x xs)"
  unfolding is_cons_def using list_rec_cons[of False "(\<lambda>_ _ _. True)"] by blast

definition "head = list_rec undefined (\<lambda>x _ _. x)"


lemma head_cons[simp]: "head (cons x xs) = x" unfolding head_def using list_rec_cons[of undefined "\<lambda>x _ _.x"] by blast

lemma head_type:
  assumes xs_cons: "xs = cons y ys"
  and xs_type: "list A xs"
  shows "mem_of A (head xs)"
  using assms list_cons_imp by auto

definition "tail = list_rec undefined (\<lambda>_ xs _. xs)"

lemma tail_cons[simp]: "tail (cons x xs) = xs" unfolding tail_def using list_rec_cons[of undefined "\<lambda>_ xs _. xs"] by auto

lemma tail_type:
  assumes xs_cons: "xs = cons y ys"
  and xs_type: "list A xs"
  shows "list A (tail xs)"
  using assms list_cons_imp by auto

definition "map f \<equiv> list_rec nil (\<lambda>x _. cons (f x))"

lemma map_type: 
  assumes "(mem_of A \<Rightarrow> mem_of B) f"
  shows "(list A \<Rightarrow> list B) (map f)"
proof -
  have "(mem_of A \<Rightarrow> list A \<Rightarrow> list B \<Rightarrow> list B) (\<lambda>x _. cons (f x))"
    using cons_type assms by blast
  with list_rec_type[where ?P="list B"] nil_type show ?thesis unfolding map_def by blast
qed

lemma map_nil_eq[simp]: "map f nil = nil"
  by (simp add: map_def list_rec_nil)

lemma map_cons_eq[simp]: "map f (cons x xs) = cons (f x) (map f xs)"
  by (simp add: map_def list_rec_cons)

definition "index_list \<equiv> list_rec nil (\<lambda>x _ xs. cons \<langle>0,x\<rangle> (map (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>) xs))"

lemma index_list_type: "(list A \<Rightarrow> list (\<omega> \<times> A)) index_list"
proof-
  have "(mem_of (\<omega> \<times> A) \<Rightarrow> mem_of (\<omega> \<times> A)) (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>)" by auto
  then have "(list (\<omega> \<times> A) \<Rightarrow> list (\<omega> \<times> A)) (map (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>))" using map_type by auto
  then have "(mem_of A \<Rightarrow> list A \<Rightarrow> list (\<omega> \<times> A) \<Rightarrow> list (\<omega> \<times> A)) (\<lambda>x _ xs. cons \<langle>0,x\<rangle> (map (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>) xs))" using cons_type[of "\<omega> \<times> A"] by fastforce
  with list_rec_type[where ?P="list (\<omega> \<times> A)"] nil_type show ?thesis unfolding index_list_def by auto
qed

lemma index_list_nil: "index_list nil = nil" unfolding index_list_def using list_rec_nil by fastforce

lemma index_list_cons: "index_list (cons x xs) = cons \<langle>0, x\<rangle> ((map (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>) (index_list xs)))"
  unfolding index_list_def using list_rec_cons[of nil "(\<lambda>x _ xs. cons \<langle>0,x\<rangle> (map (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>) xs))"] by auto


definition "nth n xs \<equiv> list_rec undefined (\<lambda>x _ res. (if (fst x = n) then snd x else res)) (index_list xs)"

lemma nth_type:
  assumes xs_cons: "xs = cons y ys"
  and xs_type: "list A xs"
  and "n \<in> \<omega>"
  and "n < length xs"
shows "mem_of A (nth n xs)"
proof-
  have index_type:"(list (\<omega> \<times> A)) (index_list xs)" using index_list_type xs_type by auto
  have inner_type:"(mem_of (\<omega> \<times> A) \<Rightarrow> list (\<omega> \<times> A) \<Rightarrow> mem_of A \<Rightarrow> mem_of A) (\<lambda>x _ res. (if (fst x = n) then snd x else res))" by fastforce
  then show ?thesis unfolding nth_def using index_type list_rec_cons xs_cons list_rec_type[of "mem_of A" "\<omega> \<times> A"] sorry
qed

definition "tuple Ps xs \<equiv> length Ps = length xs \<and> (\<forall>i. 0 \<le> i \<and> i < (length xs) \<longrightarrow> mem_of (nth i Ps) (nth i xs))"

lemma tuple_nil[simp]: "tuple nil nil" 
  unfolding tuple_def by auto

lemma nth_0: "nth 0 (cons x xs) = x" unfolding nth_def by (simp add: index_list_cons list_rec_cons)

lemma zero_ne_succ: "0 \<noteq> succ n" using succ_ne_zero by blast

lemma nth_succ: "nth (succ n) (cons x xs) = nth n xs"
proof-
  have "nth (succ n) (cons x xs) = list_rec undefined (\<lambda>x _ res. (if (fst x = succ n) then snd x else res)) (index_list (cons x xs))" using nth_def by blast
  also have "... = list_rec undefined (\<lambda>x _ res. (if (fst x = succ n) then snd x else res)) 
            (cons \<langle>0, x\<rangle> ((map (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>) (index_list xs))))" using index_list_cons by auto
  also have "... = (\<lambda> _. (if (fst \<langle>0,x\<rangle> = succ n) then snd \<langle>0,x\<rangle> else  list_rec undefined (\<lambda>x _. If (fst x = succ n) (snd x)) (map (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>) (index_list xs)))) 
  ((map (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>) (index_list xs)))" using nth_def list_rec_cons[of undefined "(\<lambda>x _ res. (if (fst x = succ n) then snd x else res))" "\<langle>0,x\<rangle>" "(map (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>) (index_list xs))"] by auto
  also have "... = (if (fst \<langle>0,x\<rangle> = succ n) then snd \<langle>0,x\<rangle> else  list_rec undefined (\<lambda>x _. If (fst x = succ n) (snd x)) (map (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>) (index_list xs)))" by blast
  also have "... = list_rec undefined (\<lambda>x _. If (fst x = succ n) (snd x)) (map (\<lambda>p. \<langle>succ (fst p), snd p\<rangle>) (index_list xs))" using zero_ne_succ by auto
  have "nth n xs = list_rec undefined (\<lambda>x _ res. (if (fst x = n) then (snd x) else res)) (index_list xs)" unfolding nth_def by blast
  show ?thesis sorry
qed


lemma tuple_cons: assumes "x \<in> p"
  and "tuple Ps xs"
  shows "tuple (cons p Ps) (cons x xs)" 
  proof-
    from \<open>tuple Ps xs\<close> have len: "length (cons p Ps) = length (cons x xs)" unfolding tuple_def using length_cons_eq_succ by auto
    from \<open>x \<in> p\<close> have 0:"mem_of (nth 0 (cons p Ps)) (nth 0 (cons x xs))" using nth_0 by auto
    from \<open>tuple Ps xs\<close> have "\<forall>i. 0 \<le> i \<and> i < (length xs) \<longrightarrow> mem_of (nth i Ps) (nth i xs)" 
      unfolding tuple_def by auto
    then have "\<forall>i. 0 \<le> i \<and> i < (length xs) \<longrightarrow> mem_of (nth (succ i) (cons p Ps)) (nth (succ i) (cons x xs))" sorry
    then have "\<forall>i. 0 \<le> i \<and> i < succ (length xs) \<longrightarrow> mem_of (nth i (cons p Ps)) (nth i (cons x xs))" sorry
    with len 0 show ?thesis unfolding tuple_def by auto
  qed

definition "replicate n x \<equiv> omega_rec nil (cons x) n"

lemma replicate_zero[simp]: "\<And>x. replicate 0 x = nil" unfolding replicate_def by auto

lemma replicate_type: "(mem_of \<omega> \<Rightarrow> mem_of A \<Rightarrow> list A) replicate"
  sorry

lemma replicate_succ: "n \<in> \<omega> \<Longrightarrow> replicate (succ n) x = cons x (replicate n x)"
  unfolding replicate_def by (rule omega_rec_succ)

lemma replicate_nth:
  assumes "n \<in> \<omega>"
  and "i \<in> \<omega>"
  and "0 \<le> i"
  and "i < n"
shows "nth i (replicate n x) = x"
using assms proof (induction n arbitrary: i rule: omega_induct)
  case zero
  then show ?case by auto
next
  case (succ m)
  then have repl_unf:"replicate (succ m) x = cons x (replicate m x)" using replicate_succ by blast
  then have nth0:"nth 0 (replicate (succ m) x) = x" using nth_0 by auto
  from repl_unf have nthsucc: "\<And>j. nth (succ j) (cons x (replicate m x)) = nth j (replicate m x)" using nth_succ by auto
  then show ?case using assms proof (cases "i = 0")
    case True
    then show ?thesis by (auto simp add: nth0)
  next
    case False
    then obtain j where "j \<in> \<omega>" "succ j = i" using \<open>i \<in> \<omega>\<close> by (auto elim: mem_omegaE)
    then have "succ j < succ m" using succ by auto
    then have "j < m" using \<open>j \<in> \<omega>\<close> \<open>m \<in> \<omega>\<close> lt_iff_mem_if_mem_omega by auto
    have "0 < j" using \<open>j \<in> \<omega>\<close> False sorry
    have "nth i (replicate (succ m) x) = nth j (replicate m x)" using \<open>succ j = i\<close> nthsucc repl_unf by auto
    also have "... = x" using succ \<open>j < m\<close> \<open>0 < j\<close> \<open>j \<in> \<omega>\<close> by auto
    finally show ?thesis by auto
  qed
qed


lemma "list P xs = tuple (replicate (length xs) P) xs"
proof
  assume "list P xs"
  then show "tuple (replicate (length xs) P) xs" proof (induction xs rule: list_induct)
    case nil
    then show ?case unfolding tuple_def by auto
  next
    case (cons x xs)
    then have "replicate (length (cons x xs)) P = cons P (replicate (length xs) P)" using replicate_succ length_type by auto
    then show ?case using tuple_cons cons by auto
  qed
next 
  assume "tuple (replicate (length xs) P) xs"
  then have "\<forall> i. i \<in> \<omega> \<and> 0 \<le> i \<and> i < length xs \<longrightarrow> mem_of P (nth i xs)" using replicate_nth tuple_def sorry
  then show "list P xs" sorry
qed

definition "vector P n xs \<equiv> length xs = n \<and> list P xs"

definition "append xs ys \<equiv> list_rec ys (\<lambda>x _. cons x) xs"

lemma nil_append_eq [simp]: "append nil ys = ys"
  by (simp add: list_rec_nil append_def)

lemma cons_append_eq [simp]:
  "append (cons x xs) ys = cons x (append xs ys)"
  by (simp add: append_def list_rec_cons)

lemma append_type: "(list A \<Rightarrow> list A \<Rightarrow> list A) append"
proof -
  have "(mem_of A \<Rightarrow> list A \<Rightarrow> list A \<Rightarrow> list A) (\<lambda>x _. cons x)"
    using cons_type by blast
  with list_rec_type[where ?P="list A"] show ?thesis unfolding append_def by blast
qed

lemma append_assoc [simp]:
  assumes "list A xs" "list A ys" "list A zs"
  shows  "append (append xs ys) zs = append xs (append ys zs)"
  using assms by (induction xs rule: list_induct) auto

definition "rev \<equiv> list_rec nil (\<lambda>x _ acc. append acc (cons x nil))"

lemma rev_nil_eq [simp]: "rev nil = nil"
  by (simp add: rev_def list_rec_nil)

lemma rev_cons_eq [simp]: "rev (cons x xs) = append (rev xs) (cons x nil)"
  by (simp add: rev_def list_rec_cons)

lemma rev_type: "(list A \<Rightarrow> list A) rev"
proof -
  have "(mem_of A \<Rightarrow> list A \<Rightarrow> list A \<Rightarrow> list A) (\<lambda>x _ acc. append acc (cons x nil))"
    using append_type cons_type nil_type by (intro mono_wrt_predI) (blast dest!: mono_wrt_predD) 
  with list_rec_type[where ?P="list A"] nil_type show ?thesis unfolding rev_def 
    by blast
qed

definition "zipWith f xs ys \<equiv> list_rec nil (\<lambda>x _ zs.(if is_nil ys then nil else cons (f x (head ys)) zs)) xs"

lemma zipWith_type:
  assumes f_type: "(mem_of A \<Rightarrow> mem_of B \<Rightarrow> mem_of C) f"
  and xs_type: "list A xs"
  and ys_type: "list B ys"
shows "list C (zipWith f xs ys)"
  sorry

lemma zipWith_nil1: "zipWith f nil ys = nil" unfolding zipWith_def using list_rec_nil[of "nil"] by blast

lemma zipWith_nil2: "zipWith f (cons x xs) nil = nil" unfolding zipWith_def using list_rec_cons[of nil "(\<lambda>x _ zs.(if is_nil nil then nil else cons (f x (head nil)) zs))"] by auto

lemma zipWith_cons: "zipWith f (cons x xs) (cons y ys) = cons (f x y) (zipWith f xs ys)" unfolding zipWith_def
  sorry


end