// Shivansh Singh: web UI interactions.
function openModal() {
    const modal = document.getElementById('habit-modal');
    modal.classList.add('open');
    modal.querySelector('input[name="name"]').focus();
}

function closeModal() {
    document.getElementById('habit-modal').classList.remove('open');
}

document.addEventListener('keydown', event => {
    if (event.key === 'Escape') closeModal();
});

document.getElementById('habit-modal').addEventListener('click', event => {
    if (event.target.id === 'habit-modal') closeModal();
});

document.querySelectorAll('.delete-btn').forEach(button => {
    button.addEventListener('click', async () => {
        if (!confirm('Delete this habit and its check-in history?')) return;
        try {
            const response = await fetch('habits?id=' + button.dataset.id, { method: 'DELETE' });
            if (response.ok) {
                location.reload();
            } else {
                alert('The habit could not be deleted. Please try again.');
            }
        } catch (error) {
            alert('Could not connect to the server. Please try again.');
        }
    });
});

document.getElementById('live-date').textContent = new Intl.DateTimeFormat('en-IN', {
    day: '2-digit', month: 'short', year: 'numeric'
}).format(new Date());
