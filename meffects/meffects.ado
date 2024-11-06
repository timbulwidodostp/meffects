********************************************************************************
* Programme       : meffects.ado                                               *
* Programmer      : Jonas Ranstam                                              *
* Programmed date : 05.03.2016                                                 *
********************************************************************************

*! meffects v1.0.0 JRanstam 18jul2015

program define meffects, rclass
   version 14
   
/* 
Syntax: meffects var [dec]

Where var is the variable whose effect size is to be calculated
      dec is the number of decimals for result
*/   
   args var dec
   preserve
   quietly {
      local var    = trim("`var'")
      local model  = e(cmdline)
      local df     = e(ddf_m)
      local model1 = subinstr("`model'","`var'","",.)
      local dummy  = subinstr("`model'"," ","_",1)
      local s1     = strpos("`dummy'"," ")
      local s2     = strpos("`model'","||")
      local model_ = substr("`model'",`s2',.)
      local model0 = substr("`model'",1,`s1') + "`model_'"

      local Vab    = exp(_b[lnsig_e:_cons])^2

      `model1'
      local Va     = exp(_b[lnsig_e:_cons])^2

      `model0'
      local Vnull   = exp(_b[lnsig_e:_cons])^2

      local R2ab    = (`Vnull'-`Vab')/`Vnull'
      local R2a     = (`Vnull'-`Va')/`Vnull'      
      local f2b     = (`R2ab'-`R2a')/(1-`R2ab')
      
      if ("`dec'"=="") local d=2 
      else local d=`dec'

      local es   : di %8.`d'f `f2b'
   }        
   
   display as txt "Effect size for `var': `es'"
   
   return scalar esize=`es'
   
   restore
end
