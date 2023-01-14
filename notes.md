# Let's reframe the project for a bit:

* We want to make snippets quickly.
* How do we do that?
    * We select text on the buffer using Visual Mode (or other tools to make selections in Neovim).
    * We get that text from Visual Selection, and insert it into a "skeleton", where:
        * We have a skeleton structure, with placeholders to insert:
            * Text (Body)
            * Trigger
            * other LuaSnip options...
    * Well, what about adding LuaSnip nodes (insert nodes, choice nodes, etc...)?
        * We're struggling because we're confused about the relationship of fmt() and replacing Body content with further placeholder.
        * --> We're dealing with multi-dimensional fmt(), or NESTED FMTs.
        * --> They're NOT NESTED! Luckily for us.
        * --> We still need to handle indentation, but that kind of indentation is different -> Handle it with our lib.string module.
        * ==> The kind of indentation we need to handle is when the user select with V mode, we track down the "smallest indent space", then "apply it to all others".
