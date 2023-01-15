# Let's reframe the project for a bit:

* We want to make snippets quickly.
* How do we do that?
    * We turn Visually Selected text into a `static` snippet.
    * The user after using that created snippet, will edit it's contents.
    * The user will manually create snapshots of the changes.
    * Program will compare the difference between the snapshots and update the snippet.
        * Potential support:
            * Insert nodes
            * Choice nodes
