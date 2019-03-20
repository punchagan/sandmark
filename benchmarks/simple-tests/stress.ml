open Printf

let list_length = int_of_string Sys.argv.(1)
let percent_retain = int_of_string Sys.argv.(2)
let words_to_allocate = 1000000000.

let rec init_list acc i n =
    if i >= n then acc
    else init_list ((ref (0,0)) :: acc) (i+1) n

let retain_list = ref (init_list [] 0 list_length)

let allocate () =
  for y = 0 to (if percent_retain > 0 then percent_retain*10 else 1000) do
    let v = (0,0) in
    if percent_retain > 0 && y mod percent_retain == 0 then
      retain_list := (ref v) :: (List.tl !retain_list)
  else
    ignore(ref v)
  done

let () = while (Gc.minor_words() < words_to_allocate) do
  allocate()
  done