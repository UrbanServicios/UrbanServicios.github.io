
//registro.js
async function registrarUsuario() {
    const form = document.getElementById('registerForm');
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;

    if (password !== confirmPassword) {
        alert('Las contraseñas no coinciden');
        return;
    }

    const formData = new FormData(form);
    const data = Object.fromEntries(formData.entries());

    try {
        const response = await fetch('http://localhost:3000/registro', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data),
        });

        if (response.ok) {
            alert('Usuario registrado correctamente');
        } else {
            const error = await response.text();
            alert(`Error: ${error}`);
        }
    } catch (err) {
        console.error(err);
        alert('Hubo un error al conectar con el servidor.');
    }
}
