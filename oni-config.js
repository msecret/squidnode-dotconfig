"use strict";
exports.__esModule = true;
exports.activate = function (oni) {
    console.log("config activated");
    // Input
    //
    // Add input bindings here:
    //
    oni.input.bind("<c-enter>", function () { return console.log("Control+Enter was pressed"); });
    //
    // Or remove the default bindings here by uncommenting the below line:
    //
    const LEADER_KEY = ('\\')
    oni.input.bind(LEADER_KEY + "t", "quickOpen.show");
    oni.input.bind("<space>", "completion.complete")
    oni.input.bind("<tab>", "completion.next")
    oni.input.bind("<shift-tab>", "completion.previous")

    oni.input.unbind("C-s")
    oni.input.bind("<C-x>", "quickOpen.openFileHorizontal")
};
exports.deactivate = function (oni) {
    console.log("config deactivated");
};
exports.configuration = {
    //add custom config here, such as
    "autoClosingPairs.enabled": false,
    "ui.colorscheme": "gruvbox",
    "oni.useDefaultConfig": false,
    //"oni.bookmarks": ["~/Documents"],
    "oni.loadInitVim": true,
    "editor.fontSize": "14px",
    "editor.fontFamily": "Hack Nerd Font Mono",
    "configuration.editor": "javascript",
    // UI customizations
    "ui.animations.enabled": true,
    "ui.fontSmoothing": "auto"
  };
