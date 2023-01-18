# Let's reframe the project for a bit:

* We want to edit existing snippets
    * Find the snippet in file
        * Find by `trigger`
        * Sort by date
    * Edit that snippet content
    * Replace old snippet with editted one

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

* UI may disrupt the user's flow of work (looking away from the current buffer),
    * But offers clear information about the snippet they're editing.

* We want the snippet creation / editting experience to be as "organic" (non-disruptive) to the user as possible.

* How about implementing both and see what the user prefers?
