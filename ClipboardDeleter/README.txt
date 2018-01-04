Clipboarddeleter 0.1.0 (090401)
======================

by Dennis Kueper, Some rights reserved.
d[at]viega[dot]de

Based on ClipboardPublisher by Frederic Hemberger, Some rights reserved. mail[at]frederic-hemberger[dot]de

Clipboarddeleter is a plug-in for RedDot CMS, which allows the SmartTree
user to delete all selected pages in the clipboard.

This is third party software. The author is not affilated in any manner with
RedDot Solutions AG or Open Text Corporation.

PURPOSE
=======
I used the plugin to delete all non connected pages of a project in one step.

INSTALLATION
============

1. Copy the /Clipboarddeleter folder to the RedDot CMS plug-in folder
   (/ASP/PlugIns).

2. Import the plugin in the ServerManager and activate it.

3. Enable plugin for your projects.



USAGE
=====
In SmartTree, select a page or a link node and choose "Delete selected pages 
in clipboard" from the Action Menu.

Known issues
============
- After selecting/deselecting pages in the clipboard, press
  "Refresh Clipboard" before using this plug-in.

- After hitting OK, you won't get an hourglass or something that 
  indicates the current state. If you selected many pages, 
  you need to *wait* until a result appears.

- The output on the last page is quick&dirty. You can not 
  assign an error to a page ID. However you can refresh the 
  clipboard to see which pages have been actually deleted 
  (they are marked by a bin icon)

VERSION HISTORY
===============

0.1.0  - Initial Release



LICENSE
=======

This software is licensed under a Creative Commons License:

Attribution-Share Alike 3.0
(http://creativecommons.org/licenses/by-sa/3.0/)

You are free:

    * to Share — to copy, distribute and transmit the work
    * to Remix — to adapt the work

Under the following conditions:

    * Attribution. You must attribute the work in the manner specified by the
      author or licensor (but not in any way that suggests that they endorse
      you or your use of the work).
    * Share Alike. If you alter, transform, or build upon this work, you may
      distribute the resulting work only under the same, similar or a
      compatible license.
    * For any reuse or distribution, you must make clear to others the license
      terms of this work.
    * Any of the above conditions can be waived if you get permission from the
      copyright holder.
    * Nothing in this license impairs or restricts the author's moral rights.



THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
