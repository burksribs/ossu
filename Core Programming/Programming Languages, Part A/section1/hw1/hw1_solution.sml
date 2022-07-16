(* year, month[1,12], day[1,31] *)
(* int * int * int *)
val date = (1999,11,22)

(*1*)
(* takes two dates, if date1 comes before date2 produces true *)
fun is_older (date1 : int * int * int, date2 : int * int * int) = (* boolean *)
    #1 date1 < #1 date2
    orelse
    (#1 date1 = #1 date2 andalso #2 date1 < #2 date2)
    orelse
    (#1 date1 = #1 date2 andalso #2 date1 = #2 date2 andalso #3 date1 < #3 date2)

(*2*)
(* returns how many dates in list are in given month *)
fun number_in_month (dates : (int * int * int) list, month : int) = (* int *)
    if null dates
    then 0
    else 
        let val rest = number_in_month((tl dates), month)
        in
            if (#2 (hd dates)) = month
            then 1 + rest
            else rest
        end

(*3*)
(*  returns how many dates in date list are in any of the months in months list
 *  Assumes that int list has no numbers repeated  *)
fun number_in_months (dates : (int * int * int) list, months : int list) = (* int *)
    if null months
    then 0
    else number_in_month(dates, (hd months)) + number_in_months(dates, (tl months))


(*4*)
fun dates_in_month (dates : (int * int * int) list, month : int) = (* (int * int * int) list *)
    if null dates
    then []
    else 
    let val rest = dates_in_month((tl dates), month)
    in 
        if (#2 (hd dates)) = month
        then (hd dates) :: rest
        else rest
    end

(*5*)
fun dates_in_months (dates : (int * int * int) list, months : int list) = (* (int * int * int) list *)
    if null months
    then []
    else dates_in_month(dates, (hd months)) @ dates_in_months(dates, (tl months))

(*6*)
fun get_nth (ls : string list, n : int) = (* string *)
    if n = 1
    then (hd ls)
    else
        get_nth((tl ls), n - 1)

(*7*)
fun date_to_string (date : int * int * int) = (* string *)
    let val months = ["January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"]
    in
        get_nth(months, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
    end

(*8*)
fun number_before_reaching_sum (sum : int, ls : int list) = (* int *)
    if sum  <= hd ls
    then 0
    else 1 + number_before_reaching_sum(sum - (hd ls), (tl ls))

(*9*)
fun what_month (day : int) = (* int *)
    let val days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    in 1 + number_before_reaching_sum(day, days_in_months)
    end

(*10*)
fun month_range (day1 : int, day2 : int) = (* int list *)
    if day1 > day2
    then []
    else what_month(day1) :: month_range(day1 + 1, day2)

(*11*)
fun oldest (dates : (int * int * int) list) = (* (int * int * int) option *)
    if null dates 
    then NONE
    else 
        let val rest = oldest(tl dates)
        in
            if not(isSome(rest)) orelse is_older(hd dates, valOf(rest))
            then SOME (hd dates)
            else rest
        end
