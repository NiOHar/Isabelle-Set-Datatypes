theory mizar_defs
imports mizar_ty

begin

definition "pred_means(prop) \<longleftrightarrow> prop"

declare pred_means_def[simp]

abbreviation (input) pred_means_p ("pred _ means _" [0,0] 10)
  where "pred df means prop \<equiv> df \<longleftrightarrow> pred_means(prop)"

lemma pred_means_property:
  assumes "pred df means prop"
  shows "(prop \<longrightarrow> df) \<and> (df \<longrightarrow> prop) \<and> (df \<longleftrightarrow> prop)"
  using assms
  unfolding pred_means_def
  by auto

definition "pred_means_if1(prop1, case1, prop_o) \<longleftrightarrow> ((case1 \<longrightarrow> prop1) \<and> (\<not>case1 \<longrightarrow> prop_o))"

abbreviation (input) pred_means_if1_p ("pred _ means _ if _ otherwise _" [0,0,0,0] 10)
  where
    "pred df means prop1 if case1 otherwise prop_o \<equiv>
      df \<longleftrightarrow> pred_means_if1(prop1, case1, prop_o)"

lemma pred_means_if1_property:
assumes "pred df means prop1 if case1 otherwise prop_o"
shows
  "(((case1 \<and> prop1) \<or> (\<not>case1 \<and> prop_o)) \<longrightarrow> df) \<and>
    (df \<longrightarrow> ((case1 \<longrightarrow> prop1) \<and> (\<not>case1 \<longrightarrow> prop_o))) \<and>
    (df \<longleftrightarrow> ((case1 \<longrightarrow> prop1) \<and> (\<not>case1 \<longrightarrow> prop_o)))"
  using assms
  unfolding pred_means_if1_def
  by auto

definition "pred_means_if2(prop1, case1, prop2, case2, prop_o) \<longleftrightarrow>
  ((case1 \<longrightarrow> prop1) \<and> (case2 \<longrightarrow> prop2) \<and> (\<not>case1 \<and> \<not>case2 \<longrightarrow> prop_o))"

abbreviation (input) pred_means_if2_p ("pred _ means _ if _ , _ if _ otherwise _" [0,0,0,0,0,0] 10)
  where
    "pred df means prop1 if case1, prop2 if case2 otherwise prop_o \<equiv>
      df \<longleftrightarrow> pred_means_if2(prop1, case1, prop2, case2, prop_o)"

lemma pred_means_if2_property:
assumes
  "pred df means prop1 if case1, prop2 if case2 otherwise prop_o" and
  "case1 \<and> case2 \<longrightarrow> (prop1 \<longleftrightarrow> prop2)"
shows
  "(((case1 \<and> prop1) \<or> (case2 \<and> prop2) \<or> (\<not>case1 \<and> \<not>case2 \<and> prop_o)) \<longrightarrow> df) \<and>
    (df \<longrightarrow> ((case1 \<longrightarrow> prop1) \<and> (case2 \<longrightarrow> prop2) \<and> (\<not>case1 \<and> \<not>case2 \<longrightarrow> prop_o))) \<and>
    (df \<longleftrightarrow> ((case1 \<longrightarrow> prop1) \<and> (case2 \<longrightarrow> prop2) \<and> (\<not>case1 \<and> \<not>case2 \<longrightarrow> prop_o)))"
  using assms
  unfolding pred_means_if2_def
  by auto
  
definition "pred_means_if3(prop1, case1, prop2, case2, prop3, case3, prop_o) \<longleftrightarrow> 
  ((case1 \<longrightarrow> prop1) \<and> (case2 \<longrightarrow> prop2) \<and> (case3 \<longrightarrow> prop3) \<and>
    (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<longrightarrow> prop_o))"

abbreviation (input)
  pred_means_if3_p ("pred _ means _ if _ , _ if _ , _ if _ otherwise _" [0,0,0,0,0,0,0,0] 10)
  where
    "pred df means prop1 if case1, prop2 if case2, prop3 if case3 otherwise prop_o \<equiv>
      df \<longleftrightarrow> pred_means_if3(prop1, case1, prop2, case2, prop3, case3, prop_o)"

lemma pred_means_if3_property:
assumes
  "pred df means prop1 if case1, prop2 if case2, prop3 if case3 otherwise prop_o" and
  "(case1 \<and> case2 \<longrightarrow> (prop1 \<longleftrightarrow> prop2)) \<and>
    (case1 \<and> case3 \<longrightarrow> (prop1 \<longleftrightarrow> prop3)) \<and>
      (case2 \<and> case3 \<longrightarrow> (prop2 \<longleftrightarrow> prop3))"
shows
  "(((case1 \<and> prop1) \<or> (case2 \<and> prop2) \<or> (case3 \<and> prop3) \<or>
    (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<and> prop_o)) \<longrightarrow> df) \<and>
  (df \<longrightarrow> ((case1 \<longrightarrow> prop1) \<and> (case2 \<longrightarrow> prop2) \<and> (case3 \<longrightarrow> prop3) \<and>
    (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<longrightarrow> prop_o))) \<and>
  (df \<longleftrightarrow> ((case1 \<longrightarrow> prop1) \<and> (case2 \<longrightarrow> prop2) \<and> (case3 \<longrightarrow> prop3) \<and>
    (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<longrightarrow> prop_o)))"
  using assms
  unfolding pred_means_if3_def
  by auto

definition "pred_antonym(prop) \<longleftrightarrow> \<not>prop"

abbreviation (input) pred_antonym_p ("antonym pred _ for _" [0,0] 10)
  where "antonym pred df for old \<equiv> df \<longleftrightarrow> pred_antonym(old)"

lemma pred_antonym_property: "antonym pred df for old \<Longrightarrow> (df \<longleftrightarrow> \<not>old)"
  unfolding pred_antonym_def by auto

definition "func_synonym(term) = term"

abbreviation (input) func_synonym_p ("synonym func _ for _" [0,0] 10)
  where "synonym func df for term \<equiv> df = func_synonym(term)"

lemma func_synonym_property: "synonym func df for term \<Longrightarrow> df = term"
  unfolding func_synonym_def by auto

definition "func_means(ty, prop) = theProp(ty, prop)"

abbreviation func_means_p ("func _ \<rightarrow> _ means _" [0,0] 10)
  where "func P \<rightarrow> R means D \<equiv> P = func_means(R, D)"

abbreviation func_assume_means_p1 ("assume1 _ func _ \<rightarrow> _ means _" [0,0,0,0] 10)
  where "assume1 as func df \<rightarrow> ty means prop \<equiv> df = the define_ty(ty, \<lambda>_. as, prop)"

definition "func_assume_means(as, ty, prop) = the define_ty(ty, \<lambda>_. as, prop)"

abbreviation func_assume_means_p ("assume _ func _ \<rightarrow> _ means _" [0,0,0,0] 10)
  where "assume as func df \<rightarrow> ty means prop \<equiv> df = func_assume_means(as, ty, prop)"

definition "func_means_if1(ty, prop1, case1, prop_o) = 
  theProp(ty, \<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (\<not>case1 \<longrightarrow> prop_o(it)))"
  
abbreviation func_means_if1_p ("func _ \<rightarrow> _ means  _ if _ otherwise _" [0,0,0,0] 10)
  where
    "func df \<rightarrow> ty means prop1 if case1 otherwise prop_o \<equiv>
      df = func_means_if1(ty, prop1, case1, prop_o)"

definition "func_assume_means_if1(as, ty, prop1, case1, prop_o) = 
   the define_ty(ty, \<lambda>_. as, \<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (\<not>case1 \<longrightarrow> prop_o(it)))"

abbreviation
  func_assume_means_if1_p ("assume _ func _ \<rightarrow> _ means  _ if _ otherwise _" [0,0,0,0,0] 10)
  where
    "assume as func df \<rightarrow> ty means prop1 if case1 otherwise prop_o \<equiv>
      df = func_assume_means_if1(as, ty, prop1, case1, prop_o)"

definition "func_means_if1o(ty, prop1, case1) = func_assume_means(case1, ty, prop1)"

abbreviation func_means_if1o_p ("func _ \<rightarrow> _ means  _ if _" [0,0,0] 10)
  where "func df \<rightarrow> ty means prop1 if case1 \<equiv> df = func_means_if1o(ty, prop1, case1)"
    
definition "func_means_if2(ty, prop1, case1, prop2, case2, prop_o) = 
  theProp(ty,
    \<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (case2 \<longrightarrow> prop2(it)) \<and> (\<not>case1 \<and> \<not>case2 \<longrightarrow> prop_o(it)))"

abbreviation func_means_if2_p ("func _ \<rightarrow> _ means  _ if _ , _ if _ otherwise _" [0,0,0,0,0,0] 10)
  where "func df \<rightarrow> ty means prop1 if case1, prop2 if case2 otherwise prop_o \<equiv>
    df = func_means_if2(ty, prop1, case1, prop2, case2, prop_o)"

definition "func_means_if2o(ty, prop1, case1, prop2, case2) = 
    func_assume_means(case1 \<or> case2, ty, \<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (case2 \<longrightarrow> prop2(it)))"

abbreviation func_means_if2o_p ("func _ \<rightarrow> _ means _ if _ , _ if _" [0,0,0,0,0] 10)
  where "func df \<rightarrow> ty means prop1 if case1, prop2 if case2 \<equiv>
    df = func_means_if2o(ty, prop1, case1, prop2, case2)"

definition "func_means_if3(ty, prop1, case1, prop2, case2, prop3, case3, prop_o) =
  theProp(ty, \<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (case2 \<longrightarrow> prop2(it)) \<and>
    (case3 \<longrightarrow> prop3(it)) \<and> (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<longrightarrow> prop_o(it)))"

abbreviation
  func_means_if3_p ("func _ \<rightarrow> _ means  _ if _ , _ if _ , _ if _ otherwise _" [0,0,0,0,0,0,0,0] 10)
  where
    "func df \<rightarrow> ty means prop1 if case1, prop2 if case2, prop3 if case3 otherwise prop_o \<equiv> 
      df = func_means_if3(ty, prop1, case1, prop2, case2, prop3, case3, prop_o)"

definition "func_means_if4(ty, prop1, case1, prop2, case2, prop3, case3, prop4, case4, prop_o) =
  theProp(ty,
    \<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (case2 \<longrightarrow> prop2(it)) \<and>
      (case3 \<longrightarrow> prop3(it)) \<and> (case4 \<longrightarrow> prop4(it)) \<and>
      (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<and> \<not>case4 \<longrightarrow> prop_o(it)))"

abbreviation func_means_if4_p ("func _ \<rightarrow> _ means  _ if _ , _ if _ , _ if _ , _ if _ otherwise _"
  [0,0,0,0,0,0,0,0,0,0] 10)
  where
  "func df \<rightarrow> ty means prop1 if case1, prop2 if case2,
    prop3 if case3, prop4 if case4 otherwise prop_o \<equiv>
      df = func_means_if4(ty, prop1, case1, prop2, case2, prop3, case3, prop4, case4, prop_o)"

lemma func_means_property:
assumes
  df: "func df \<rightarrow> ty means prop" and
  m: "inhabited(ty)" and
  ex: "\<exists>x: ty. prop(x)" and
  un: "\<And>x y. \<lbrakk>x be ty; y be ty; prop(x); prop(y)\<rbrakk> \<Longrightarrow> x = y"
shows "df be ty \<and> (x be ty \<and> prop(x) \<longrightarrow> x = df) \<and> prop(df)"
unfolding df func_means_def
proof (intro conjI)
  have *: "\<exists>\<^sub>Lx. x be define_ty(ty, \<lambda>_. True, prop)"
    using Bex_def m ex by squash_types auto
  hence **: "theProp(ty,prop) be define_ty(ty, \<lambda>_. True, prop)"
    using choice_ax inhabited_def by blast
  thus "theProp(ty,prop) be ty" by squash_types
  show "prop(theProp(ty,prop))" using * ** by squash_types
  show "x be ty \<and> prop(x) \<longrightarrow> x = theProp(ty, prop)" using un ** by squash_types auto
qed
  
lemma func_assume_means_property:
assumes
  df: "assume as func df \<rightarrow> ty means prop" and
  assume_ex: "as \<Longrightarrow> \<exists>x: ty. prop(x)" and
  assume_un: "\<And>x y. \<lbrakk>as; x be ty; y be ty; prop(x); prop(y)\<rbrakk> \<Longrightarrow> x = y" and
  mode_ex: "inhabited(ty)"
shows
   "df be ty \<and> (as \<and> x be ty \<and> prop(x) \<longrightarrow> x = df) \<and> (as \<longrightarrow> prop(df))"
proof (cases "as")
  assume as: "as"
  hence as_df: "df = theProp(ty, prop)"
    using df func_assume_means_def by simp
  show "df be ty \<and> (as \<and> x be ty \<and> prop(x) \<longrightarrow> x = df) \<and> (as \<longrightarrow> prop(df))"
    using
      func_means_property[unfolded func_means_def, OF as_df mode_ex assume_ex[OF as]]
      assume_un as
    by auto
next
  assume nas: "\<not>as"
  have "(the ty) be ty" using choice_ax mode_ex by auto
  hence "inhabited(define_ty(ty, \<lambda>_. as, prop))"
    using define_ty_property[of _ ty "\<lambda>_. as", THEN conjunct2] nas
    by auto
  hence "df be define_ty(ty, \<lambda>_. as, prop)"
    using choice_ax df[unfolded func_assume_means_def] by blast
  thus "df be ty \<and> (as \<and> x be ty \<and> prop(x) \<longrightarrow> x = df) \<and> (as \<longrightarrow> prop(df))"
    using define_ty_property[of _ ty "\<lambda>_. as", THEN conjunct1] nas by blast
qed

lemma func_means_if1_property:
assumes
  df: "func df \<rightarrow> ty means prop1 if case1 otherwise prop_o" and
  m: "inhabited(ty)" and
  ex: "(case1 \<longrightarrow> (\<exists>x: ty. prop1(x))) \<and> (\<not>case1 \<longrightarrow> (\<exists>x: ty. prop_o(x)))" and
  un: "\<And>x y. x be ty \<Longrightarrow> y be ty \<Longrightarrow>
    (case1 \<and> prop1(x) \<and> prop1(y) \<longrightarrow> x = y) \<and> (\<not>case1 \<and> prop_o(x) \<and> prop_o(y) \<longrightarrow> x = y)"
shows
  "df be ty \<and>
    (x be ty \<longrightarrow> ((case1 \<and> prop1(x)) \<or> (\<not>case1 \<and> prop_o(x))) \<longrightarrow> x = df) \<and>
    ((case1 \<longrightarrow> prop1(df)) \<and> (\<not>case1 \<longrightarrow> prop_o(df)))"
proof -
  let ?C = "\<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (\<not>case1 \<longrightarrow> prop_o(it))"
  have dfF: "df = func_means(ty, ?C)"
    using df unfolding func_means_def func_means_if1_def by auto
  have exF: "\<exists>x: ty. ?C(x)"
    using ex m by blast
  have unF: "\<And>x y. x be ty \<Longrightarrow> y be ty \<Longrightarrow> ?C(x) \<Longrightarrow> ?C(y) \<Longrightarrow> x = y"
    using un by blast
  show ?thesis
    using func_means_property[OF dfF m exF unF] by auto
qed

lemma func_assume_means_if1_property:
assumes
  df: "assume as func df \<rightarrow> ty means prop1 if case1 otherwise prop_o" and
  assume_ex: "as \<Longrightarrow> (case1 \<longrightarrow> (\<exists>x: ty. prop1(x))) \<and> (\<not>case1 \<longrightarrow> (\<exists>x: ty. prop_o(x)))" and
  assume_un: "\<And>x y. as \<Longrightarrow> x be ty \<Longrightarrow> y be ty \<Longrightarrow>
    (case1 \<and> prop1(x) \<and> prop1(y) \<longrightarrow> x = y) \<and> (\<not>case1 \<and> prop_o(x) \<and> prop_o(y) \<longrightarrow> x = y)" and
  mode_ex: "inhabited(ty)"
shows
  "df be ty \<and>
    (as \<and> x be ty \<longrightarrow> ((case1 \<and> prop1(x)) \<or> (\<not>case1 \<and> prop_o(x))) \<longrightarrow> x = df ) \<and>
    (as \<longrightarrow> (case1 \<longrightarrow> prop1(df)) \<and> (\<not>case1 \<longrightarrow> prop_o(df)))"
proof -
  let ?C = "\<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (\<not>case1 \<longrightarrow> prop_o(it))"
  have D: "assume as func df \<rightarrow> ty means ?C"
    using df func_assume_means_if1_def func_assume_means_def by auto
  have ex: "as \<Longrightarrow> \<exists>x: ty. ?C(x)"
    using assume_ex mode_ex by auto
  have un: "\<And>x y. as \<Longrightarrow> x be ty \<Longrightarrow> y be ty \<Longrightarrow> ?C(x) \<Longrightarrow> ?C(y) \<Longrightarrow> x = y"
    using assume_un by auto
  thus ?thesis
    using func_assume_means_property[OF D ex un mode_ex] by auto
qed

lemma func_means_if2_property:
assumes
  df: "func df \<rightarrow> ty means prop1 if case1, prop2 if case2 otherwise prop_o" and
  m: "inhabited(ty)" and
  ex: "(case1 \<longrightarrow> (\<exists>x: ty. prop1(x))) \<and> (case2 \<longrightarrow> (\<exists>x: ty. prop2(x))) \<and>
    (\<not>case1 \<and> \<not>case2 \<longrightarrow> (\<exists>x: ty. prop_o(x)))" and
  un: "\<And>x y. x be ty \<Longrightarrow> y be ty \<Longrightarrow>
    (case1 \<and> prop1(x) \<and> prop1(y) \<longrightarrow> x = y) \<and>
    (case2 \<and> prop2(x) \<and> prop2(y) \<longrightarrow> x = y) \<and>
    (\<not>case1 \<and> \<not>case2 \<and> prop_o(x) \<and> prop_o(y) \<longrightarrow> x = y)" and
  co:"\<forall>x: ty. case1 \<and> case2 \<longrightarrow> (prop1(x) \<longleftrightarrow> prop2(x))"
shows
  "df be ty
    \<and> (x be ty
      \<longrightarrow> ((case1 \<and> prop1(x)) \<or> (case2 \<and> prop2(x)) \<or> (\<not>case1 \<and> \<not>case2 \<and>  prop_o(x)))
      \<longrightarrow> x = df)
    \<and> ((case1 \<longrightarrow> prop1(df)) \<and> (case2 \<longrightarrow>prop2(df)) \<and> (\<not>case1 \<and> \<not>case2 \<longrightarrow> prop_o(df)))"
proof -
  let ?C = "\<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (case2 \<longrightarrow> prop2(it)) \<and> (\<not>case1 \<and> \<not>case2 \<longrightarrow> prop_o(it))"
  have dfF: "df= func_means(ty, ?C)"
    using df unfolding func_means_def func_means_if2_def by auto
  have exF: "\<exists>x: ty. ?C(x)"
    using ex m co by blast
  have unF: "\<And>x y. x be ty \<Longrightarrow> y be ty \<Longrightarrow> ?C(x) \<Longrightarrow> ?C(y) \<Longrightarrow> x = y"
    using un by blast
  show ?thesis
    using func_means_property[OF dfF m exF unF,of x] co[THEN bspec] m by auto
qed

lemma func_means_if3_property:
assumes
  df: "func df \<rightarrow> ty means prop1 if case1, prop2 if case2, prop3 if case3 otherwise prop_o" and
  m: "inhabited(ty)" and
  ex: "(case1 \<longrightarrow>
        (\<exists>x: ty. prop1(x))) \<and>
        (case2 \<longrightarrow> (\<exists>x: ty. prop2(x))) \<and>
        (case3 \<longrightarrow> (\<exists>x: ty. prop3(x))) \<and>
        (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<longrightarrow> (\<exists>x: ty. prop_o(x)))" and
  un: "\<And>x y. \<lbrakk>x be ty; y be ty\<rbrakk> \<Longrightarrow>
        (case1 \<and> prop1(x) \<and> prop1(y) \<longrightarrow> x = y) \<and>
        (case2 \<and> prop2(x) \<and> prop2(y) \<longrightarrow> x = y) \<and>
        (case3 \<and> prop3(x) \<and> prop3(y) \<longrightarrow> x = y) \<and>
        (\<not>case1 \<and> \<not>case2\<and> \<not>case3 \<and> prop_o(x) \<and> prop_o(y) \<longrightarrow> x = y)" and
  co: "\<forall>x: ty. (case1 \<and> case2 \<longrightarrow> (prop1(x) \<longleftrightarrow> prop2(x))) \<and>
        (case1 \<and> case3 \<longrightarrow> (prop1(x) \<longleftrightarrow> prop3(x))) \<and>
        (case2 \<and> case3 \<longrightarrow> (prop2(x) \<longleftrightarrow> prop3(x)))"
shows "df be ty
        \<and> (x be ty
          \<longrightarrow> ((case1 \<and> prop1(x)) \<or> (case2 \<and> prop2(x)) \<or>
              (case3 \<and> prop3(x)) \<or> (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<and> prop_o(x)))
          \<longrightarrow> x = df)
        \<and> ((case1 \<longrightarrow> prop1(df)) \<and> (case2 \<longrightarrow> prop2(df)) \<and> (case3 \<longrightarrow> prop3(df))
          \<and> (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<longrightarrow> prop_o(df)))"
proof -
  let ?C = "\<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (case2 \<longrightarrow> prop2(it)) \<and> (case3 \<longrightarrow> prop3(it)) \<and>
    (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<longrightarrow> prop_o(it))"
  have dfF:" df = func_means(ty, ?C)"
    using df unfolding func_means_def func_means_if3_def by auto
  have exF: "\<exists>x: ty. ?C(x)"
    proof (cases "case1 \<or> case2")
      case True thus ?thesis using ex m co by blast
      next case False thus ?thesis using ex m co by auto
    qed
    have unF: "\<And>x y. x be ty \<Longrightarrow> y be ty \<Longrightarrow> ?C(x) \<Longrightarrow> ?C(y) \<Longrightarrow> x = y" 
    proof -
      fix x y assume A: "x be ty" "y be ty"
      assume C: "?C(x)" "?C(y)"
      have T1: "case1 \<or> case2 \<longrightarrow> x = y"
        using un[OF A] C[THEN conjunct1] C[THEN conjunct2, THEN conjunct1]
        by auto
      have T2: "case3 \<longrightarrow> x = y"
        using un[OF A] C[THEN conjunct2, THEN conjunct2]
        by auto
      have "\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<longrightarrow> x = y"
        using un[OF A] C[THEN conjunct2, THEN conjunct2, THEN conjunct2]
        by auto
      thus "x = y" using T1 T2 by auto
    qed
  show ?thesis
    using func_means_property[OF dfF m exF unF, of x] co[THEN bspec] m
    by auto
qed

lemma func_means_if4_property:
assumes df: "func df \<rightarrow> ty means prop1 if case1, prop2 if case2,
              prop3 if case3, prop4 if case4 otherwise prop_o"
  and m: "inhabited(ty)"
  and ex: "(case1 \<longrightarrow> (\<exists>x: ty. prop1(x))) \<and>
        (case2 \<longrightarrow> (\<exists>x: ty. prop2(x))) \<and>
        (case3 \<longrightarrow> (\<exists>x: ty. prop3(x))) \<and>
        (case4 \<longrightarrow> (\<exists>x: ty. prop4(x))) \<and>
        (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<and> \<not>case4 \<longrightarrow> (\<exists>x: ty. prop_o(x)))"
  and un: "\<And>x y. \<lbrakk>x be ty; y be ty\<rbrakk> \<Longrightarrow>
        (case1 \<and> prop1(x) \<and> prop1(y) \<longrightarrow> x = y) \<and>
        (case2 \<and> prop2(x) \<and> prop2(y) \<longrightarrow> x = y) \<and>
        (case3 \<and> prop3(x) \<and> prop3(y) \<longrightarrow> x = y) \<and>
        (case4 \<and> prop4(x) \<and> prop4(y) \<longrightarrow> x = y) \<and>
        (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<and> \<not>case4 \<and> prop_o(x) \<and> prop_o(y) \<longrightarrow> x = y)"
  and co: "\<forall>x: ty. (case1 \<and> case2 \<longrightarrow> (prop1(x) \<longleftrightarrow> prop2(x))) \<and>
        (case1 \<and> case3 \<longrightarrow> (prop1(x) \<longleftrightarrow> prop3(x))) \<and>
        (case1 \<and> case4 \<longrightarrow> (prop1(x) \<longleftrightarrow> prop4(x))) \<and>
        (case2 \<and> case3 \<longrightarrow> (prop2(x) \<longleftrightarrow> prop3(x))) \<and>
        (case2 \<and> case4 \<longrightarrow> (prop2(x) \<longleftrightarrow> prop4(x))) \<and>
        (case3 \<and> case4 \<longrightarrow> (prop3(x) \<longleftrightarrow> prop4(x)))"
shows "df be ty
      \<and> (x be ty
        \<longrightarrow> ((case1 \<and> prop1(x)) \<or> (case2 \<and> prop2(x)) \<or>
          (case3 \<and> prop3(x)) \<or> (case4 \<and> prop4(x)) \<or>
          (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<and> \<not>case4 \<and> prop_o(x)))
        \<longrightarrow> x = df)
      \<and> ((case1 \<longrightarrow> prop1(df)) \<and> (case2 \<longrightarrow> prop2(df)) \<and> (case3 \<longrightarrow> prop3(df)) \<and>
          (case4 \<longrightarrow> prop4(df)) \<and> (\<not>case1 \<and> \<not>case2 \<and> \<not>case3 \<and> \<not>case4 \<longrightarrow> prop_o(df)))"
proof -
  let ?C = "\<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (case2 \<longrightarrow> prop2(it)) \<and> (case3 \<longrightarrow> prop3(it)) \<and>
            (case4 \<longrightarrow> prop4(it)) \<and> (\<not>case1 \<and> \<not>case2 \<and> \<not>case3\<and> \<not>case4 \<longrightarrow> prop_o(it))"
  have dfF:" df = func_means(ty, ?C)"
    using df
    unfolding func_means_def func_means_if4_def
    by auto
  have exF: "\<exists>x:ty. ?C(x)" 
  proof (cases "case1 \<or> case2")
    case True thus ?thesis using ex m co by blast
    next case False thus ?thesis using ex m co by auto
  qed
  have unF: "\<And>x y. x be ty \<Longrightarrow> y be ty \<Longrightarrow> ?C(x) \<Longrightarrow> ?C(y) \<Longrightarrow> x = y"
  proof -
    fix x y assume A: "x be ty" "y be ty" and C: "?C(x)" "?C(y)"
    have T1: "case1 \<or> case2 \<longrightarrow> x = y"
      using un[OF A] C[THEN conjunct1] C[THEN conjunct2, THEN conjunct1]
      by auto
    have T2: "case3 \<or> case4 \<longrightarrow> x = y"
      using un[OF A] C[THEN conjunct2,THEN conjunct2] by auto
    have "\<not>case1 \<and> \<not>case2 \<and> \<not>case3\<and> \<not>case4 \<longrightarrow> x = y"
      using un[OF A] C[THEN conjunct2, THEN conjunct2, THEN conjunct2]
      by auto
    thus "x=y" using T1 T2 by auto
  qed 
  show ?thesis
    using func_means_property[OF dfF m exF unF, of x] co[THEN bspec] m
    by auto
qed

lemma func_means_if1o_property:
assumes df: "func df \<rightarrow> ty means prop1 if case1"
  and m: "inhabited(ty)"
  and ex: "case1 \<longrightarrow> (\<exists>x: ty. prop1(x))"
  and un: "\<And>x y. x be ty \<Longrightarrow> y be ty \<Longrightarrow> (case1 \<and> prop1(x) \<and> prop1(y) \<longrightarrow> x = y)"
shows "df be ty
       \<and> (x be ty \<longrightarrow> (case1 \<and> prop1(x)\<longrightarrow> x = df))
       \<and> (case1 \<longrightarrow> prop1(df))"
  using ex un m
    func_assume_means_property[of df case1 ty prop1, OF df[unfolded func_means_if1o_def]]
  by auto

lemma func_means_if2o_property:
assumes df: "func df \<rightarrow> ty means prop1 if case1, prop2 if case2"
  and m: "inhabited(ty)"
  and ex: "(case1 \<longrightarrow> (\<exists>x: ty. prop1(x))) \<and> (case2 \<longrightarrow> (\<exists>x:ty. prop2(x)))"
  and un: "\<And>x y. \<lbrakk>x be ty; y be ty\<rbrakk> \<Longrightarrow>
            (case1 \<and> prop1(x) \<and> prop1(y) \<longrightarrow> x = y) \<and>
            (case2 \<and> prop2(x) \<and> prop2(y) \<longrightarrow> x = y)"
  and co: "\<forall>x: ty. case1 \<and> case2 \<longrightarrow> (prop1(x) \<longleftrightarrow> prop2(x))"
shows "df be ty
       \<and> (x be ty \<longrightarrow> ((case1 \<and> prop1(x)) \<or> (case2 \<and> prop2(x))) \<longrightarrow> x = df)
       \<and> ((case1 \<longrightarrow> prop1(df)) \<and> (case2 \<longrightarrow> prop2(df)))"
proof -
  let ?C = "\<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (case2 \<longrightarrow> prop2(it))"
  have dfF: "df = func_assume_means(case1 \<or> case2, ty, ?C)"
    using df
    unfolding func_assume_means_def func_means_if2o_def
    by auto
  show ?thesis
    using func_assume_means_property[OF dfF, of x] co m un ex
    by auto
qed

   
subsection \<open> "func equals" \<close>

definition "func_equals(ty, def) = func_means (ty, \<lambda>it. it = def)"

abbreviation func_equals_p ("func _ \<rightarrow> _ equals _" [0,0] 10)
  where "func df \<rightarrow> ty equals term \<equiv> df = func_equals(ty, term)"

definition "func_assume_equals(as, ty, def) = func_assume_means(as, ty, \<lambda>it. it = def)"

abbreviation func_assume_equals_p ("assume _ func _ \<rightarrow> _ equals _" [0,0,0] 10)
  where "assume as func df \<rightarrow> ty equals term \<equiv> df = func_assume_equals(as, ty, term)"    

definition "func_equals_if1(ty, term1, case1, term_o) =
  func_means_if1(ty, \<lambda>it. it = term1, case1, \<lambda>it. it = term_o)"

abbreviation func_equals_if1_p ("func _ \<rightarrow> _ equals _ if _ otherwise _" [0,0,0,0] 10)
  where
    "func df \<rightarrow> ty equals term1 if case1 otherwise term_o \<equiv>
      df = func_equals_if1(ty, term1, case1, term_o)"

definition "func_equals_if1o(ty, term1, case1) = func_means_if1o(ty, \<lambda>it. it = term1, case1)"

abbreviation func_equals_if1o_p ("func _ \<rightarrow> _ equals _ if _" [0,0,0] 10)
  where "func df \<rightarrow> ty equals term1 if case1 \<equiv> df = func_equals_if1o(ty, term1, case1)"

definition "func_equals_if2(ty, term1, case1, term2, case2, term_o) =
  func_means_if2(ty, \<lambda>it. it = term1, case1, \<lambda>it. it = term2, case2, \<lambda>it. it = term_o)"

abbreviation func_equals_if2_p ("func _ \<rightarrow> _ equals _ if _, _ if _ otherwise _" [0,0,0,0,0,0] 10)
  where
    "func df \<rightarrow> ty equals term1 if case1, term2 if case2 otherwise term_o \<equiv>
      df = func_equals_if2(ty, term1, case1, term2, case2, term_o)"

definition "func_equals_if2o(ty, term1, case1, term2, case2) =
  func_means_if2o (ty, \<lambda>it. it = term1, case1, \<lambda>it. it = term2, case2)"

abbreviation func_equals_if2o_p ("func _ \<rightarrow> _ equals _ if _, _ if _" [0,0,0,0,0] 10)
  where
    "func df \<rightarrow> ty equals term1 if case1, term2 if case2 \<equiv>
      df = func_equals_if2o(ty, term1, case1, term2, case2)"

lemma func_equals_property:
assumes df: "func df \<rightarrow> ty equals term"
  and coherence: "term be ty"
shows "df be ty \<and> df = term"
  using func_means_property[OF df[unfolded func_equals_def]] inhabited_def coherence
  by auto

lemma func_assume_equals_property:
assumes df: "assume as func df \<rightarrow> ty equals term"
  and assume_coherence: "as \<Longrightarrow> term be ty"
  and mode_ex: "inhabited(ty)"
shows
   "df be ty \<and> (as \<longrightarrow> df = term)"
proof -
  have assume_ex: "as \<Longrightarrow> ex x being ty st x = term"
    using assume_coherence mode_ex
    by auto
  show "?thesis"
    using
      func_assume_means_property[OF df[unfolded func_assume_equals_def] assume_ex, OF _ _ mode_ex]
    by auto
qed

lemma func_equals_if1_property:
assumes df: "func df \<rightarrow> ty equals term1 if case1 otherwise term_o"
  and coherence: "(case1 \<longrightarrow> term1 be ty) \<and> (\<not>case1 \<longrightarrow> term_o be ty)"
shows "df be ty \<and> ((case1 \<longrightarrow> df = term1) \<and> (\<not>case1 \<longrightarrow> df = term_o))"
  using func_means_if1_property[OF df[unfolded func_equals_if1_def]] inhabited_def coherence
  by auto

lemma func_equals_if1o_property:
assumes df: "func df \<rightarrow> ty equals term1 if case1"
  and m:"inhabited(ty)"
  and coherence: "(case1 \<longrightarrow> term1 be ty)"
shows "df be ty \<and> (case1 \<longrightarrow> df = term1)"
  using func_means_if1o_property[OF df[unfolded func_equals_if1o_def]] m coherence
  by auto

lemma func_equals_if2_property:
assumes
  df: "func df \<rightarrow> ty equals term1 if case1, term2 if case2 otherwise term_o" and
  coherence: "(case1 \<longrightarrow> term1 be ty) \<and>
              (case2 \<longrightarrow> term2 be ty) \<and>
              (\<not>case1 \<and> \<not>case2 \<longrightarrow> term_o be ty)" and
  co: "\<forall>x: ty. case1 \<and> case2 \<longrightarrow> (x = term1 \<longleftrightarrow> x = term2)"
shows "df be ty \<and>
        ((case1 \<longrightarrow> df = term1) \<and> (case2 \<longrightarrow> df = term2) \<and> (\<not>case1 \<and> \<not>case2 \<longrightarrow> df = term_o))"
  using func_means_if2_property[OF df[unfolded func_equals_if2_def]] coherence inhabited_def co
  by auto

lemma func_equals_if2o_property:
assumes
  df: "func df \<rightarrow> ty equals term1 if case1, term2 if case2" and
  coherence: "(case1 \<longrightarrow> term1 be ty) \<and>
              (case2 \<longrightarrow> term2 be ty) \<and>
              (\<not>case1 \<and> \<not>case2 \<longrightarrow> term_o be ty)" and
  co: "\<forall>x: ty. case1 \<and> case2 \<longrightarrow> (x = term1 \<longleftrightarrow> x = term2)"
shows "df be ty \<and> ((case1 \<longrightarrow> df = term1) \<and> (case2 \<longrightarrow> df = term2))"
  using func_means_if2o_property[OF df[unfolded func_equals_if2o_def]] coherence co inhabited_def
  by auto


subsection \<open> "mode means" \<close>

definition "mode_means(p, prop) \<equiv> define_ty(p, \<lambda>_.True, prop)"

abbreviation mode_means_p ("mode _ \<rightarrow> _ means _" [10,10,10] 10)
  where "mode df \<rightarrow> ty means prop \<equiv> df =\<^sub>T mode_means(ty, prop)"

abbreviation mode_assume_means_p1 ("assume1 _ mode _ \<rightarrow> _ means _" [0,0,0,0] 10)
  where "assume1 as mode df \<rightarrow> ty means prop \<equiv> df =\<^sub>T define_ty(ty, \<lambda>_.as, prop)"

definition "mode_assume_means(ty, as, prop) \<equiv> define_ty(ty, \<lambda>_.as, prop)"

abbreviation mode_assume_means_p ("assume _ mode _ \<rightarrow> _ means _" [0,0,0,0] 10)
  where "assume as mode df \<rightarrow> ty means prop \<equiv> df =\<^sub>T mode_assume_means(ty, as, prop)"

definition "mode_means_if1(p, prop1, case1, prop_o) \<equiv>
  mode_means(p, \<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (\<not>case1 \<longrightarrow> prop_o(it)))"

abbreviation mode_means_if1_p ("mode _ \<rightarrow> _ means '(_ if _ otherwise _ ')" [0,0,0,0,0] 10)
  where "mode df \<rightarrow> ty means (prop1 if case1 otherwise prop_o) \<equiv>
    df =\<^sub>T mode_means_if1(ty, prop1, case1, prop_o)"

lemma mode_means_property:
assumes df: "mode df \<rightarrow> ty means prop"
  and m: "inhabited(ty)"
  and ex: "\<exists>x: ty. prop(x)"
shows "inhabited(df) \<and> 
        (x be df \<longrightarrow> x be ty) \<and>
        (x be ty \<longrightarrow> prop(x)\<longrightarrow> x be df) \<and>
        (x be df \<longrightarrow> prop(x)) \<and>
        (x be ty \<longrightarrow> (x be df \<longleftrightarrow>  prop(x)))"
proof -
  obtain x where "x be ty \<and> prop(x)"
    using ex m
    by auto
  hence "x be df"
    using ex define_ty_property_true df mode_means_def
    by auto
  thus ?thesis
    using ex define_ty_property_true df mode_means_def inhabited_def
    by auto
qed

lemma mode_assume_means_property:
assumes df: "assume as mode df \<rightarrow> ty means prop"
  and m: "inhabited(ty)"
  and assume_ex: "as \<Longrightarrow> ex x being ty st prop(x)"
shows "inhabited(df) \<and>
        (x be df \<longrightarrow> x be ty) \<and>
        (as \<longrightarrow> x be ty \<longrightarrow> prop(x)\<longrightarrow> x be df) \<and>
        (x be df \<longrightarrow> as \<longrightarrow> prop(x)) \<and>
        (as \<longrightarrow> x be ty \<longrightarrow> (x be df \<longleftrightarrow>  prop(x)))"     
proof (cases "as")
  assume r: "as"
  hence rdf:"df =\<^sub>T mode_means(ty, prop)"
    using df mode_assume_means_def mode_means_def
    by simp
  show ?thesis
    using mode_means_property[OF rdf m assume_ex[OF r], of x] r
    by blast
next
  assume nr:"not as"
  hence rdf: "df \<equiv> define_ty(ty, \<lambda>_. as, prop)"
    using df mode_assume_means_def mode_means_def
    by simp
  have "(the ty) be ty"
    using choice_ax m
    by auto
  thus ?thesis
    using define_ty_property[OF rdf, of x]
      define_ty_property[OF rdf, of "the ty", THEN conjunct2] nr
    by blast
qed

lemma mode_means_if1_property:
assumes df: "mode df \<rightarrow> ty means (prop1 if case1 otherwise prop_o)"
  and m: "inhabited(ty)"
  and ex: "(case1 \<longrightarrow> (\<exists>x: ty. prop1(x))) \<and> (\<not>case1 \<longrightarrow> (\<exists>x: ty. prop_o(x)))"
shows "inhabited(df) \<and>
        (x be df \<longrightarrow> x be ty) \<and>
        (x be ty \<longrightarrow> (case1 \<and> prop1(x)) \<or> (\<not>case1 \<and> prop_o(x)) \<longrightarrow> x be df) \<and>
        (x be df \<longrightarrow> (case1 \<longrightarrow> prop1(x)) \<and> (\<not>case1 \<longrightarrow> prop_o(x))) \<and>
        (x be ty \<longrightarrow> (x be df \<longleftrightarrow> (case1 \<longrightarrow> prop1(x)) \<and> (\<not>case1 \<longrightarrow> prop_o(x))))"
proof -
  let ?C = "\<lambda>it. (case1 \<longrightarrow> prop1(it)) \<and> (\<not>case1 \<longrightarrow> prop_o(it))"
  have dfF: "df=\<^sub>T mode_means(ty, ?C)"
    using df unfolding mode_means_if1_def
    by auto
  have exF: "\<exists>x:ty. ?C(x)"
    using ex m
    by blast
  show ?thesis
    using mode_means_property[OF dfF m exF, of x]
    by blast
qed 


subsection \<open> "attr means" \<close>
    
definition "attr_means(ty, prop) \<equiv> define_ty(object, \<lambda>it. it be ty, prop)"

abbreviation attr_means_p ("attr _ for _ means _" [10,10,10] 10)
  where "attr df for ty means prop \<equiv> df =\<^sub>T attr_means(ty, prop)"

definition "attr_means_if1(ty, prop1, case1, prop_o) \<equiv>
  define_ty(object, \<lambda>it. it be ty, \<lambda>it. (case1(it) \<longrightarrow> prop1(it)) \<and> (\<not>case1(it) \<longrightarrow> prop_o(it)))"

abbreviation attr_means_if1_p ("attr _ for _ means  _ if _ otherwise _" [0,0,0,0,0] 10)
  where "attr df for ty means prop1 if case1 otherwise prop_o \<equiv>
    df =\<^sub>T attr_means_if1(ty, prop1, case1, prop_o)"

definition "attr_assume_means(as, ty, prop) \<equiv> define_ty(object, \<lambda>it. it be ty \<and> as(it), prop)"

abbreviation attr_assume_means_p ("assume _ attr _ for _ means _" [0,0,0,0] 10)
  where "assume as attr df for ty means prop \<equiv> df =\<^sub>T attr_assume_means(as, ty, prop)"

lemma attr_means_property:
assumes "attr df for ty means prop"
shows "(X be ty \<longrightarrow> prop(X) \<longrightarrow> X is df) \<and>
        (X be ty \<longrightarrow> X is df \<longrightarrow> prop(X)) \<and>
        (X be ty \<longrightarrow> \<not>prop(X) \<longrightarrow> X is non df) \<and>
        (X be ty \<longrightarrow> (X is df \<longleftrightarrow> prop(X)))"
  using assms unfolding attr_means_def 
  by (squash_types, auto)+

lemma attr_assume_means_property:
assumes "assume as attr df for ty means prop"
shows "(X be ty \<longrightarrow> as(X) \<longrightarrow> prop(X) \<longrightarrow> X is df) \<and>
        (X be ty \<longrightarrow> as(X)\<longrightarrow> X is df \<longrightarrow> prop(X)) \<and>
        (X be ty \<longrightarrow> as(X) \<longrightarrow> \<not> prop(X) \<longrightarrow> X is non df) \<and>
        (X be ty \<longrightarrow> as(X) \<longrightarrow> (X is df \<longleftrightarrow> prop(X)))"
  using define_ty_property[of assms object "\<lambda>it. it be ty \<and> as(it)" "prop" X] assms
  unfolding attr_assume_means_def
  by (squash_types, auto)+
            
lemma attr_means_if1_property:
assumes "attr df for ty means prop1 if case1 otherwise prop_o"
shows "(X be ty \<longrightarrow> (case1(X) \<and> prop1(X)) \<or> (\<not>case1(X) \<and> prop_o(X)) \<longrightarrow> X is df) \<and>
        (X be ty \<longrightarrow> X is df \<longrightarrow> (case1(X) \<longrightarrow> prop1(X)) \<and> (\<not>case1(X) \<longrightarrow> prop_o(X))) \<and>
        (X be ty \<longrightarrow>
          (case1(X) \<longrightarrow> (X is df \<longleftrightarrow> prop1(X))) \<and> (\<not> case1(X) \<longrightarrow> (X is df \<longleftrightarrow> prop_o(X))))"
  using def_ty_property_object assms attr_means_if1_def
  by auto


subsection \<open> clusters \<close>
               
definition "ClusterCondAttrsAttrsTy(attrs1, attrs2, ty) \<equiv>
  (\<And>X. (X is ty \<longrightarrow> X is attrs1 \<longrightarrow> X is attrs2))"

abbreviation (input) ClusterCondAttrsAttrsTy_p ("cluster _ \<rightarrow> _ for _" [0,0,0] 10)
  where "cluster attrs1 \<rightarrow> attrs2 for ty \<equiv> ClusterCondAttrsAttrsTy(attrs1, attrs2, ty)"

lemma ClusterCondAttrsAttrsTyI[intro!]:
assumes "\<forall>it: ty. (it is attrs1 \<longrightarrow> it is attrs2)" and "inhabited(ty)"
shows "cluster attrs1 \<rightarrow> attrs2 for ty"
  using ClusterCondAttrsAttrsTy_def assms
  by auto

lemma ClusterCondAttrsAttrsTy_property:
assumes "cluster attrs1 \<rightarrow> attrs2 for ty" 
shows "\<And>X. X be ty \<Longrightarrow> X is attrs1 \<Longrightarrow> X is attrs2"
  using assms unfolding ClusterCondAttrsAttrsTy_def by simp

definition "ClusterCondAttrsTy(attrs2, ty) \<equiv> (\<And> X. (X be ty \<longrightarrow> X is attrs2))"

abbreviation (input) ClusterCondAttrsTy_p ("cluster \<rightarrow> _ for _" [0,0] 10)
  where "cluster \<rightarrow> attrs2 for ty \<equiv> ClusterCondAttrsTy(attrs2, ty)"

lemma ClusterCondAttrsTyI[intro!]:
assumes "\<forall>it: ty. it is attrs2" and "inhabited(ty)"
shows "cluster \<rightarrow> attrs2 for ty"
  using ClusterCondAttrsTy_def assms by auto

lemma ClusterCondAttrsTy_property:
assumes "cluster \<rightarrow> attrs2 for ty" 
shows "\<And>X. X be ty \<Longrightarrow> X is attrs2"
  using assms unfolding ClusterCondAttrsTy_def by simp

definition "ClusterExistence(attrs, ty) \<equiv> Trueprop(inhabited(attrs \<bar> ty))"

abbreviation (input) ClusterExistence_p ("cluster _ for _" [0,0] 10)
  where "cluster attrs for ty \<equiv> ClusterExistence(attrs, ty)"

lemma ClusterExistenceI[intro!]: "inhabited(attrs \<bar> ty) \<Longrightarrow> cluster attrs for ty"
  unfolding ClusterExistence_def by auto

lemma ClusterExistence_property: "cluster attrs for ty \<Longrightarrow> inhabited(attrs\<bar>ty)"
  unfolding ClusterExistence_def by auto

definition "ClusterFuncNoFor(fun, attrs) \<equiv> Trueprop(fun is attrs)"

abbreviation (input) ClusterFuncNoFor_p ("cluster  _ \<rightarrow> _" [0,0] 10)
  where "cluster fun \<rightarrow> attrs \<equiv> ClusterFuncNoFor(fun, attrs)"

(* This was not a property! *)
lemma ClusterFuncNoForI[intro!]: "fun is attrs \<Longrightarrow> cluster fun \<rightarrow> attrs"
  unfolding ClusterFuncNoFor_def by auto

lemma ClusterFuncNoFor_property: "cluster fun \<rightarrow> attrs \<Longrightarrow> fun is attrs"
  unfolding ClusterFuncNoFor_def .

definition "ClusterFuncFor(fun, attrs, ty) \<equiv> (fun is ty \<Longrightarrow> fun is attrs)"

abbreviation (input) ClusterFuncFor_p ("cluster _ \<rightarrow> _ fors _" [0,0,0] 10)
  where "cluster fun \<rightarrow> attrs fors ty \<equiv> ClusterFuncFor(fun, attrs, ty)"

lemma ClusterFuncForI[intro!]:
assumes
  coherence: "\<forall>it: ty. it = fun \<longrightarrow> it is attrs" and
  i: "inhabited(ty)"
shows "cluster fun \<rightarrow> attrs fors ty" 
  using ClusterFuncFor_def coherence[THEN bspec, of "fun"] i
  by auto

lemma ClusterFuncFor_property:
assumes "cluster fun \<rightarrow> attrs fors ty" 
shows "fun is ty \<Longrightarrow> fun is attrs"
  using assms unfolding ClusterFuncFor_def .

definition "Reduce(term, subterm) \<equiv>  Trueprop(term = subterm)"

abbreviation (input) Reduce_p ("reduce _ to _" [0,0] 10)
  where "reduce term to subterm \<equiv> Reduce(term, subterm)"

lemma ReduceI[intro!]: "term = subterm \<Longrightarrow> reduce term to subterm" 
  using Reduce_def by auto
        
lemma Reduce_property: "reduce term to subterm \<Longrightarrow> term = subterm"
  unfolding Reduce_def .


subsection \<open> "redefine func means" \<close>

definition "redefine_func_means(df, ty, prop) \<equiv> (\<And>x. (x be ty \<and> prop(x) \<longrightarrow> x = df) \<and> prop(df))"

abbreviation (input) redefine_func_means_p ("redefine func _ \<rightarrow> _ means _" [0,0,0] 10)
  where "redefine func df \<rightarrow> ty means prop \<equiv> redefine_func_means(df, ty, prop)"

definition "redefine_func_means_if1(df, ty, prop1, case1, prop_o) \<equiv>
  (\<And>x. (x be ty \<longrightarrow> (case1 \<and> prop1(x)) \<or> (\<not>case1 \<and> prop_o(x)) \<longrightarrow> x = df) \<and>
    ((case1 \<longrightarrow> prop1(df)) \<and> (\<not>case1 \<longrightarrow> prop_o(df))))"

abbreviation
  redefine_func_means_if1_p ("redefine func _ \<rightarrow> _ means  _ if _ otherwise _ " [0,0,0,0] 10)
  where
    "redefine func df \<rightarrow> ty means prop1 if case1 otherwise prop_o \<equiv>
      redefine_func_means_if1(df, ty, prop1, case1, prop_o)"

definition "redefine_func_assume_means(df, as, ty, prop) \<equiv>
  (\<And>x. (as \<and> x be ty \<and> prop(x) \<longrightarrow> x = df) \<and> (as \<longrightarrow> prop(df)))"

abbreviation (input)
  redefine_func_assume_means_p ("assume _ redefine func _ \<rightarrow> _ means _" [0,0,0,0] 10)
  where
    "assume as redefine func df \<rightarrow> ty means prop \<equiv> redefine_func_assume_means(df, as, ty, prop)"

definition "redefine_func_means_if1o(df, ty, prop1, case1) \<equiv>
  redefine_func_assume_means(df, case1, ty, prop1)"

abbreviation redefine_func_means_if1o_p ("redefine func _ \<rightarrow> _ means  _ if _" [0,0,0,0] 10)
  where "redefine func df \<rightarrow> ty means prop1 if case1 \<equiv>
    redefine_func_means_if1o(df, ty, prop1, case1)"

lemma redefine_func_meansI[intro!]:
assumes "\<And>x. x be ty \<Longrightarrow> (x = df \<longleftrightarrow> newProp(x))" and "df is ty"
shows "redefine func df \<rightarrow> ty means newProp"
  unfolding redefine_func_means_def using assms by auto

lemma redefine_func_means_property:
assumes "redefine func df \<rightarrow> ty means newProp"
shows "(x be ty \<and> newProp(x) \<longrightarrow> x = df) \<and> newProp(df)"
  using assms unfolding redefine_func_means_def by auto

lemma redefine_func_means_if1I[intro!]:
assumes
  "\<And>x. x be ty \<Longrightarrow> (case1 \<longrightarrow> (x = df \<longleftrightarrow> prop1(x))) \<and> (\<not>case1 \<longrightarrow> (x = df \<longleftrightarrow> prop_o(x)))" and
  "df is ty"
shows "redefine func df \<rightarrow> ty means prop1 if case1 otherwise prop_o"
  unfolding redefine_func_means_if1_def
  using assms by auto

lemma redefine_func_means_if1_property:
assumes "redefine func df \<rightarrow> ty means prop1 if case1 otherwise prop_o"
shows
  "(x be ty \<longrightarrow> (case1 \<and> prop1(x)) \<or> (\<not>case1 \<and> prop_o(x)) \<longrightarrow> x = df)
        \<and> ((case1 \<longrightarrow> prop1(df)) \<and> (\<not>case1 \<longrightarrow> prop_o(df)))"
using assms unfolding redefine_func_means_if1_def by auto

lemma redefine_func_assume_meansI[intro!]:
assumes "\<And>x . as \<and> x be ty \<Longrightarrow> (x = df \<longleftrightarrow> newProp(x))" and "df is ty"
shows "assume as redefine func df \<rightarrow> ty means newProp"
  unfolding redefine_func_assume_means_def using assms by auto

lemma redefine_func_assume_means_property:
assumes "assume as redefine func df \<rightarrow> ty means newProp"
shows "(as \<and> x be ty \<and> newProp(x) \<longrightarrow> x = df) \<and> (as \<longrightarrow> newProp(df))"
  using assms unfolding redefine_func_assume_means_def by auto

lemma redefine_func_means_if1oI[intro!]:
assumes "\<And>x. prop \<and> x be ty \<Longrightarrow> (x = df \<longleftrightarrow> newProp(x))" and "df is ty"
shows "redefine func df \<rightarrow> ty means newProp if prop"
  unfolding redefine_func_means_if1o_def redefine_func_assume_means_property
  using assms
  by auto

lemma redefine_func_means_if1o_property:
assumes "redefine func df \<rightarrow> ty means newProp if prop"
shows "(prop \<and> x be ty \<and> newProp(x) \<longrightarrow> x = df) \<and> (prop \<longrightarrow> newProp(df))"
  using redefine_func_assume_means_property[
    of df "prop" ty newProp x,
    OF assms [unfolded redefine_func_means_if1o_def[of df ty newProp "prop"]]]
  by simp

subsection \<open> "redefine func equals" \<close>
    
definition "redefine_func_equals(df, ty::Ty, term) \<equiv> Trueprop(df = term)"

abbreviation (input) redefine_func_equals_p ("redefine func _ \<rightarrow> _ equals _" [0,0,0] 10)
  where "redefine func df \<rightarrow> ty equals term \<equiv> redefine_func_equals(df, ty, term)"

definition "redefine_func_assume_equals(as, df, ty::Ty, term) \<equiv> Trueprop(as \<longrightarrow> df = term)"

abbreviation (input)
  redefine_func_assume_equals_p ("assume _ redefine func _ \<rightarrow> _ equals _" [0,0,0,0] 10)
  where
    "assume as redefine func df \<rightarrow> ty equals term \<equiv> redefine_func_assume_equals(as, df, ty, term)"

definition "redefine_func_equals_if1(df, ty::Ty, term1, case1, term_o) \<equiv>
  Trueprop((case1 \<longrightarrow>  df = term1) \<and> (\<not>case1 \<longrightarrow> df = term_o))"

abbreviation
  redefine_func_equals_if1_p ("redefine func _ \<rightarrow> _ equals _ if _ otherwise _" [0,0,0,0,0] 10)
  where
    "redefine func df \<rightarrow> ty equals term1 if case1 otherwise term_o \<equiv>
      redefine_func_equals_if1(df, ty, term1, case1, term_o)"

lemma redefine_func_equals_if1I[intro!]:
assumes
  "\<And>x. x be ty \<Longrightarrow> (case1 \<longrightarrow> (x = df \<longleftrightarrow> x = term1)) \<and> (\<not>case1 \<longrightarrow> (x = df \<longleftrightarrow> x = term_o))" and
  "df is ty"
shows "redefine func df \<rightarrow> ty equals term1 if case1 otherwise term_o"
  unfolding redefine_func_equals_if1_def redefine_func_means_property
  using assms
  by auto

lemma redefine_func_equals_if1_property:
assumes "redefine func df \<rightarrow> ty equals term1 if case1 otherwise term_o"
shows "(case1 \<longrightarrow> df = term1) \<and> (\<not>case1 \<longrightarrow> df = term_o)"
  using assms
  unfolding redefine_func_equals_if1_def
  by auto

lemma redefine_func_equalsI[intro!]:
assumes "\<And>x. x be ty \<Longrightarrow> (x = df \<longleftrightarrow> x = term)" and "df is ty"
shows "redefine func df \<rightarrow> ty equals term"
  unfolding redefine_func_equals_def using assms by auto
   
lemma redefine_func_equals_property: "redefine func df \<rightarrow> ty equals term \<Longrightarrow> df = term"
  unfolding redefine_func_equals_def by auto
    
lemma redefine_func_assume_equalsI[intro!]:
assumes "\<And>x. as \<and> x be ty \<Longrightarrow> (x = df \<longleftrightarrow> x = term)" and "df is ty"
shows "assume as redefine func df \<rightarrow> ty equals term"
  unfolding redefine_func_assume_equals_def using assms by auto
   
lemma redefine_func_assume_equals_property:
  "assume as redefine func df \<rightarrow> ty equals term \<Longrightarrow> as \<longrightarrow> df = term"
  unfolding redefine_func_assume_equals_def by auto


subsection \<open> redefine func type \<close>        
        
definition "redefine_func_type(df, ty) \<equiv> Trueprop(df be ty)"

abbreviation (input) redefine_func_type_p ("redefine func _ \<rightarrow> _" [0,0] 10)
  where "redefine func df \<rightarrow> ty \<equiv> redefine_func_type(df, ty)"

lemma redefine_func_typeI[intro!]: "df be ty \<Longrightarrow> redefine func df \<rightarrow> ty"
  unfolding redefine_func_type_def by auto

lemma redefine_func_type_property: "redefine func df \<rightarrow> ty \<Longrightarrow> df be ty"
  unfolding redefine_func_type_def by auto


subsection \<open> redefine mode \<close>

definition "redefine_mode_means(df, ty, prop) \<equiv> (\<And>x. x be ty \<longrightarrow> (x be df \<longleftrightarrow> prop(x)))"

abbreviation (input) redefine_mode_means_p ("redefine mode _ \<rightarrow> _ means _" [0,0,0] 10)
  where "redefine mode df \<rightarrow> ty means prop \<equiv> redefine_mode_means(df, ty, prop)"

lemma redefine_mode_meansI[intro!]:
assumes "\<And>x. x be ty \<Longrightarrow> (x is df \<longleftrightarrow> prop(x))"
shows "redefine mode df \<rightarrow> ty means prop"
  unfolding redefine_mode_means_def using assms by auto

lemma redefine_mode_means_property:
assumes "redefine mode df \<rightarrow> ty means prop"
shows "(X be ty \<longrightarrow> prop(X) \<longrightarrow> X is df) \<and>
        (X be ty \<longrightarrow> X is df \<longrightarrow> prop(X)) \<and>
        (X be ty \<longrightarrow> (X is df \<longleftrightarrow> prop(X)))"
  using assms unfolding redefine_mode_means_def by auto


subsection \<open> redefine attr \<close>

definition "redefine_attr_means(ty, Attr, prop) \<equiv> (\<And>x. x is ty \<longrightarrow> (x is Attr \<longleftrightarrow> prop(x)))"

abbreviation (input) redefine_attr_means_p ("redefine attr _ for _ means _" [0,0,0] 10)
  where "redefine attr Attr for ty means prop \<equiv> redefine_attr_means(ty, Attr, prop)"

lemma redefine_attr_meansI[intro!]:
assumes "\<forall>x: ty. x is Attr \<longleftrightarrow> prop(x)" and "inhabited(ty)"
shows "redefine attr Attr for ty means prop"
  unfolding redefine_attr_means_def using assms by auto

lemma redefine_attr_means_property:
assumes "redefine attr Attr for ty means prop"
shows "(x is ty \<and> prop(x) \<longrightarrow> x is Attr) \<and>
        (x is ty \<and> x is Attr \<longrightarrow> prop(x)) \<and>
        (x is ty \<longrightarrow> (x is Attr \<longleftrightarrow> prop(x)))"
  using assms unfolding redefine_attr_means_def by auto

subsection \<open> redefine pred \<close>

definition "redefine_pred_means(Pred, prop) \<equiv> Trueprop(Pred \<longleftrightarrow> prop)"

abbreviation (input) redefine_pred_means_p ("redefine pred _ means _" [0,0] 10)
  where "redefine pred P means prop \<equiv> redefine_pred_means(P, prop)"

lemma redefine_pred_meansI[intro!]: "P \<longleftrightarrow> prop \<Longrightarrow> redefine pred P means prop"
  unfolding redefine_pred_means_def by auto

lemma redefine_pred_means_property:
  "redefine pred P means prop \<Longrightarrow> (prop \<longrightarrow> P) \<and> (P \<longrightarrow> prop) \<and> (P \<longleftrightarrow> prop)"
  unfolding redefine_pred_means_def by auto

definition "redefine_pred_means_if1(Pred, prop1, case1, prop_o) \<equiv>
  ((case1\<longrightarrow> (Pred  \<longleftrightarrow> prop1)) \<and> (\<not>case1 \<longrightarrow> (Pred  \<longleftrightarrow> prop_o)))"

abbreviation (input)
  redefine_pred_means_if1_p ("redefine pred _ means _ if _ otherwise _" [0,0,0,0] 10)
  where
    "redefine pred P means prop1 if case1 otherwise prop_o \<equiv>
      redefine_pred_means_if1(P, prop1, case1, prop_o)"

lemma redefine_pred_means_if1_property:
assumes "redefine pred P means prop1 if case1 otherwise prop_o"
shows "(((case1 \<longrightarrow> prop1) \<and> (\<not>case1 \<longrightarrow> prop_o)) \<longrightarrow> P) \<and>
        (P \<longrightarrow> ((case1 \<longrightarrow> prop1) \<and> (\<not>case1 \<longrightarrow> prop_o))) \<and>
        (P \<longleftrightarrow> ((case1 \<longrightarrow> prop1) \<and> (\<not>case1 \<longrightarrow> prop_o)))"
  using assms unfolding redefine_pred_means_if1_def by auto

subsection \<open> Some abbreviations \<close>

abbreviation (input) prefix_asymmetry ("asymmetry _ _")
where "asymmetry dom R \<equiv> for x1, x2 being dom holds \<not>(R(x1, x2) \<and> R(x2, x1))"

abbreviation (input) prefix_irreflexive ("irreflexivity _ _")
where "irreflexivity dom R \<equiv> \<forall>x: dom. \<not>R(x, x)"

abbreviation (input) prefix_reflexive ("reflexivity _ _")
where "reflexivity dom R \<equiv> \<forall>x: dom. R(x, x)"

abbreviation (input) prefix_symmetry ("symmetry _ _")
where "symmetry dom R \<equiv> for x1, x2 being dom st R(x1, x2) holds R(x2, x1)"

abbreviation (input) prefix_connectedness ("connectedness _ _")
where "connectedness dom R \<equiv> for x1, x2 being dom holds R(x1, x2) \<or> R(x2, x1)"

abbreviation (input) prefix_involutiveness ("involutiveness _ _")
where "involutiveness dom U \<equiv> for x being dom holds U(U(x)) = x"

abbreviation (input) prefix_projectivity ("projectivity _ _")
where "projectivity dom U \<equiv> for x being dom holds U(U(x)) = U(x)"

abbreviation (input) prefix_idempotence ("idempotence _ _")
where "idempotence dom B \<equiv> for x being dom holds B(x, x) = x"

abbreviation (input) prefix_commutativity ("commutativity _ _")
where "commutativity dom B \<equiv> \<forall>x1: dom. \<forall>x2: dom. B(x1, x2) = B(x2, x1)"

lemmas [simp] = choice_ax

end
