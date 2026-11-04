// Shivansh Singh: web UI interactions.
function openModal(){document.getElementById('habit-modal').classList.add('open');document.querySelector('#habit-modal input[name="name"]').focus()}
function closeModal(){document.getElementById('habit-modal').classList.remove('open')}
document.addEventListener('keydown',e=>{if(e.key==='Escape')closeModal()})
document.getElementById('habit-modal').addEventListener('click',e=>{if(e.target.id==='habit-modal')closeModal()})
document.querySelectorAll('.delete-btn').forEach(button=>button.addEventListener('click',async()=>{if(!confirm('Delete this habit and its check-in history?'))return;const response=await fetch('habits?id='+button.dataset.id,{method:'DELETE'});if(response.ok)location.reload()}))
document.getElementById('live-date').textContent=new Intl.DateTimeFormat('en-IN',{day:'2-digit',month:'short',year:'numeric'}).format(new Date())
