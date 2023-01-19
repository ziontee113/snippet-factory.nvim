# Let's reframe the project for a bit:

* We want to edit existing snippets
    * Find the snippet in file
        * Find by `trigger`
        * Sort by date
    * Edit that snippet content
    * Replace old snippet with edited one

* Requirements:
    * Given a file path, get all snippets as strings, put them in a Lua table.
    * Given an already created snippet, detect it's placeholders.
        * What form will this information take?

# UI or UI-less?

* UI-less takes less work (to build the UI).
    * But offers less information to the user editting the snippet.
    * A hypothetical workflow:
        * The user triggers the snippet they want to edit
        * They use `<leader>se` mapping (for SnippetEdit)
        * They see all the placeholders gets overlayed with uniquely colored extmarks
          to indicate placeholder locations
        * They can enter Visual Mode, select the region to turn into placeholder,
          then use `<leader>ep` mapping (for EditPlaceHolder)
        * They use `<leader>ss` mapping (for SnippetSave)
    * Hypothetical additional mappings:
        * `<leader>sc` (for SnippetChoices) to see / add choices to this placeholder.
            * Now we show a pop-up window to for show the user choices for this node.
            * Within this pop-up window, user can add / remove choices.
            * This pop-up is just a regular nvim buffer, each line of the buffer
              will be a choice for this node.
                * --> Problem arises when multi-line nodes are involved.
                * --> How do we deal with this?
                * ==> We could visually select those multi-lines, mark them with sign-column extmarks,
                      each choice will have a different sign-column extmark color.
                * ==> We could instead of letting users use this pop-up as a regular buffer,
                      instead, we have custom mappings like `a` to add a choice, `dd` to delete a choice.
                      Then we can manage multi-line choices.
    * Hypothetical things to try out:
        * Replace all placeholders with `choiceNodes` with `insertNodes` inside them, instead of `insertNodes`.
    * Potential Pluming Jobs to do:
        * Getting the correct snippet from **snippet files**
            * Or we could use a database...😨
            * If this can be done, we can have a "jump to snippet location" functionality.
            * This involves **reading all files** in the snippet directory, which is very **inefficient**.
                * We could limit for snippet files that corresponds to the current buffer's filetype only.
                * --> The smarter solution could be using `ripgrep` to search for that snippet,
                      then read & parse only that file, then get that snippet with Treesitter.
                      -> But we still need that **date metadata** to search correctly.
        * Storing **metadata** for to edit snippets easier.
            * What kind of metadata do we potentially need to store?
                * Original Content before we create the snippet
                * Time snippet was created with snippet-factory.nvim

* UI may disrupt the user's flow of work (looking away from the current buffer),
    * But offers clear information about the snippet they're editing.

* We want the snippet creation / editing experience to be as "organic" (non-disruptive) to the user as possible.

* How about implementing both and see what the user prefers?



# Smart Snippet Creation / Editing

## Update existing snippet from it's usage

## Create snippets from repetitive code
