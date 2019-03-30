defmodule DemoWeb.HangMan do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div phx-keydown="keydown" phx-target="window">
      <h1>Hello hangman</h1>
      <div>Lives left:<%= @lives %></div>
      <%= if @lives == 0 do %>
        <h2>Game Over :(</h2>
      <% end %>
      <%= if !String.contains?(@wordFound, "_") do %>
        <h2>Win !!</h2>
      <% end %>
      <div class="word-found"><%= @wordFound %></div>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok,
     assign(socket,
       keypress: "",
       word: "octo technology",
       isLetterFound: false,
       wordFound: "____ __________",
       lettersFound: "",
       lives: 5
     )}
  end

  def handle_event("keydown", key, socket) do
    word = socket.assigns.word
    lives = socket.assigns.lives
    word = socket.assigns.word
    wordFound = socket.assigns.wordFound
    isLetterFound = String.contains?(word, key)
    lettersFound = socket.assigns.lettersFound
    newLives = if lives > 0, do: lives - 1, else: 0

    if isLetterFound do
      lettersFound = lettersFound <> key
      wordFound = String.replace(word, ~r/[^#{lettersFound}]/, "_")

      {:noreply,
       assign(socket,
         keypress: key,
         isLetterFound: isLetterFound,
         lettersFound: lettersFound,
         wordFound: wordFound
       )}
    else
      {:noreply,
       assign(socket,
         keypress: key,
         isLetterFound: isLetterFound,
         lives: newLives,
         wordFound: wordFound
       )}
    end
  end
end
