// Copyright 2026 The Naja Authors
// Copyright 2022 Alan Shreve (@inconshreveable)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Package mousetrap answers a single question: on Windows, was this process
// started by someone double-clicking the executable in explorer.exe?
//
// CLI tools started that way typically print their help into a console window
// that closes immediately. Detecting the situation lets a program show more
// helpful instructions instead.
//
// This package is a hard fork of github.com/inconshreveable/mousetrap v1.1.0
// by Alan Shreve, used under the Apache License 2.0.
package mousetrap
