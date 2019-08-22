section \<open>More monotone operators\<close>

theory Monops
imports Set_Lattice Ordered_Pair

begin

lemma monop_prodI [derive]:
  assumes
    A_type[type]: "A : monop (Univ X)" and
    B_type[type]: "B : monop (Univ X)"
  shows
    "(\<lambda>x. A x \<times> B x) : monop (Univ X)"

  by (rule monopI, discharge_types) (auto dest: monopD2[OF A_type] monopD2[OF B_type])


end