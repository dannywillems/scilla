(*
 * Copyright (c) 2018 - present Zilliqa, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *)


open Core
open Printf
open Sexplib.Std
open Syntax
open EvalUtil
open Recursion

let () =
  let filename = Sys.argv.(1) in
  match FrontEndParser.parse_file ScillaParser.exps filename with
  | Some [e] ->
      let recs = List.map ~f:(fun (a, b, _) -> (a, b)) recursion_principles in
      let env = Env.bind_all Env.empty recs in
      let res = Eval.exp_eval e env in
      (match res with
      | Ok (v, env) ->
          printf "%s\n" (Eval.pp_result res)
      | Error _ -> printf "Failed execution:\n%s\n" (Eval.pp_result res))
  | Some _ | None ->
      printf "%s\n" "Failed to parse input file."
  


