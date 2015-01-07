* SPSS Python Extension function to calculate the mode of a set of variables
* by Jamie DeCoster

* Usage: varMode(varList, modeVar)
* "varList" is a list of variables for which you want the mode
* "modeVar" is the name of the variable you want assigned to the mode

* If there are multiple values with equivalent counts, the mode will be
* assigned to whichever one comes first alphabetically

* EXAMPLE: varMode(["rank1", "rank2", "rank3", "rank4", "rank5"], "scoreMode")
* This will set the value of "scoreMode" for each subject to be equal to be
* the mode of that subject's five ranks.
    
***********
* Version History
***********
* 2015-01-06 Created
* 2015-01-07 Removed test variables

set printback=off.
begin program python.
import spss

def varMode(varList, modeVar):
    VMvarnum = len(varList)

# Define necessary variables
    submitstring = """numeric #VMval1 to #VMval{0} (f8.4).
numeric #VMcount1 to #VMcount{0} (f8.0).
vector VMvalue = #VMval1 to #VMval{0}.
vector VMcount = #VMcount1 to #VMcount{0}.
""".format(VMvarnum)
    spss.Submit(submitstring)

# Count the number for each value
    submitstring = """compute #VMfilled = 0.
loop #VMt = 1 to {0}.
+    compute VMvalue(#VMt) = $sysmis.
+    compute VMcount(#VMt) = $sysmis.
end loop.
do repeat VMvar = """.format(VMvarnum)
    for VMvar in varList:
        submitstring = submitstring + "\n" + VMvar
    submitstring = submitstring + """.
+    do if (not missing(VMvar)).
+        do if (#VMfilled = 0).
+            compute #VMfilled = 1.
+            compute #VMval1 = VMvar.
+            compute #VMcount1 = 1.
+        else.
+            compute #VMfound = 0.
+            loop #VMt = 1 to #VMfilled.
+                do if (VMvar = VMvalue(#VMt)).
+                    compute #VMfound = 1.
+                    compute VMcount(#VMt) = VMcount(#VMt) + 1.
+                end if.
+            end loop.
+            do if (#VMfound = 0).
+                compute #VMfilled = #VMfilled + 1.
+                compute VMvalue(#VMfilled) = VMvar.
+                compute VMcount(#VMfilled) = 1.
+            end if.
+        end if.
+    else.
+    end if.
end repeat.
"""
    spss.Submit(submitstring)

# Identify values that have maximum counts and
# choose value with maximum counts that comes first alphabetically

    submitstring = """compute #VMmaxcount = max(#VMcount1 to #VMcount{0}).
compute #VMmaxvalue = $sysmis.
loop #VMt = 1 to {0}.
+    do if (VMcount(#VMt) = #VMmaxcount).
+        if (VMvalue(#VMt) < #VMmaxvalue) #VMmaxvalue = VMvalue(#VMt).
+        if (missing(#VMmaxvalue)) #VMmaxvalue = VMvalue(#VMt).
+    end if.
end loop.
compute {1} = #VMmaxvalue.
execute.""".format(VMvarnum, modeVar)
    spss.Submit(submitstring)

end program python.
set printback=on.