# Install renv if not already installed
if (!requireNamespace("renv", quietly = TRUE)) {
  install.packages("renv")
}

# Initialize renv in your project
# renv::init()

# renv::snapshot()

# renv::update()
# renv::restore()

# Make sure you're using the latest rsconnect
# install.packages("rsconnect")

# Deploy your app
# rsconnect::deployApp(
#   appDir = ".",
#   appName = "Wild-Tooehy",
#   account = "your-account-name"
# )

# Create a manifest that can then be used with the GUI upload
rsconnect::writeManifest(
  appDir = ".",
  appFiles = c(
    "app.R",
    # The entire modules directory
    "modules",
    # The entire www directory
    "www",
    # renv files
    ".Rprofile",
    "renv.lock",
    "renv/activate.R"
  )
)

rsconnect::deployApp(
  appDir = ".",
  appName = "Wild-Toohey",
  account = "wildspire",
  server = "shinyapps.io"
)

# The full manual approach
# rsconnect::deployApp(
#   appDir = ".",
#   appFiles = c(
#     "app.R",
#     # The entire modules directory
#     "modules",
#     # The entire www directory
#     "www",
#     # renv files
#     ".Rprofile",
#     "renv.lock",
#     "renv/activate.R"
#   ),
#   appName = "Wild-Toohey",
#   account = "wildspire", # Your shinyapps.io account name
#   server = "shinyapps.io" # The server (usually shinyapps.io)
# )
