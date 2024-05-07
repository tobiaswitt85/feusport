// eslint.config.js
module.exports = [
    {
        rules: {
            semi: "error",
            "prefer-const": "error"
        },
        files: [
            "app/javascript/**/* "
        ],
        languageOptions: {
          ecmaVersion: 6
        }
    }
];
