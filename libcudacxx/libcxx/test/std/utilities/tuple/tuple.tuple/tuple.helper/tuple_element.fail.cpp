//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <tuple>

// template <class... Types> class tuple;

// template <size_t I, class... Types>
// struct tuple_element<I, tuple<Types...> >
// {
//     typedef Ti type;
// };

// UNSUPPORTED: c++98, c++03

#include <tuple>
#include <type_traits>

int main(int, char**)
{
    using T =  std::tuple<int, long, void*>;
    using E1 = typename std::tuple_element<1, T &>::type; // expected-error{{undefined template}}
    using E2 = typename std::tuple_element<3, T>::type;
    using E3 = typename std::tuple_element<4, T const>::type;
        // expected-error-re@__tuple_dir/tuple_element.h:* 2 {{{{(static_assert|static assertion)}} failed{{.*}} {{"?}}tuple_element index out of range{{"?}}}}


  return 0;
}
