RSS: Who logged in? 0.1.0 (090401)
==================================

by Dennis Kueper, Some rights reserved.
d[at]viega[dot]de

"Who logged in?" is an asp vbscript which returns an RSS file you can 
read with an RSS reader like FeedDemon. It tells the administrator 
(or every other user depending on the file rights) who logged in to a project and when.

This is third party software. The author is not affilated in any manner with
RedDot Solutions AG or Open Text Corporation.

INSTALLATION
============

1. Add a Reddot scriptuser to your system that you can use for executing the script or just use your own user in step 2.

2. Edit the .asp file with your Notepad. Change to your values until line 18.

3. Copy the rss.asp to the Reddot Webserver (e.g. c:\Inetpub\wwwroot\rql)

4. Add access rights in the iis if you need to


USAGE
=====
1) Call the file with http://yourserver/rql/user_lastlogin.asp in your browser to get a plain list.

or 

2) Add http://yourserver/rql/user_lastlogin.asp?typ=RSS to your RSS reader and enjoy.


Known issues
============
- Source is very quick&dirty
- not 100% RSS compliant
- not heavily tested

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
