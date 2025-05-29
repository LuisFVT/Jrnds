document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('ponenteForm');
    const successAlert = document.getElementById('successAlert');
    const errorAlert = document.getElementById('errorAlert');
    const loadingIndicator = document.getElementById('loadingIndicator');
    const submitButton = form.querySelector('button[type="submit"]');

    // Mostrar alertas
    function showAlert(alertElement, message) {
        alertElement.textContent = message;
        alertElement.style.display = 'block';
        setTimeout(() => {
            alertElement.style.display = 'none';
        }, 5000);
    }

    // Validar formulario
    function validateForm() {
        // Validar checkboxes
        const checkboxes = form.querySelectorAll('input[name="tipo_participacion[]"]:checked');
        if (checkboxes.length === 0) {
            showAlert(errorAlert, 'Debe seleccionar al menos un tipo de participación');
            return false;
        }

        // Validar presentación
        if (form.elements['presentacion'].value.length < 100) {
            showAlert(errorAlert, 'La presentación debe tener al menos 100 caracteres');
            return false;
        }

        return true;
    }

    // Manejar el envío del formulario
    async function handleSubmit(e) {
        e.preventDefault();

        if (!validateForm()) return;

        try {
            loadingIndicator.style.display = 'block';
            submitButton.disabled = true;

            const formData = new FormData(form);
            const response = await fetch(form.action, {
                method: 'POST',
                body: formData
            });

            // Verificar primero si hay error HTTP
            if (!response.ok) {
                const errorText = await response.text();
                throw new Error(`Error del servidor (${response.status}): ${extractErrorMessage(errorText)}`);
            }

            // Verificar si es JSON
            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                const text = await response.text();
                throw new Error(`La API devolvió HTML en lugar de JSON. Contacte al administrador. Detalles: ${text.substring(0, 100)}...`);
            }

            const result = await response.json();

            if (result.success) {
                showAlert(successAlert, result.message);
                form.reset();
            } else {
                throw new Error(result.message || 'Error al procesar la solicitud');
            }
        } catch (error) {
            console.error('Error completo:', error);
            showAlert(errorAlert, error.message);
        } finally {
            loadingIndicator.style.display = 'none';
            submitButton.disabled = false;
        }
    }

    // Extraer mensaje de error de HTML (para cuando PHP devuelve errores)
    function extractErrorMessage(html) {
        try {
            // Intentar extraer contenido de tags <b>
            const doc = new DOMParser().parseFromString(html, 'text/html');
            const boldTags = doc.getElementsByTagName('b');
            if (boldTags.length > 0) {
                return boldTags[0].textContent;
            }
            
            // O intentar extraer contenido de tags <p>
            const pTags = doc.getElementsByTagName('p');
            if (pTags.length > 0) {
                return pTags[0].textContent;
            }
            
            return html.substring(0, 200); // Devolver parte del texto si no se encuentra nada
        } catch (e) {
            return html.substring(0, 200);
        }
    }

    // Configurar validaciones en tiempo real
    function setupValidations() {
        // Validación de presentación
        form.elements['presentacion'].addEventListener('input', function() {
            this.setCustomValidity(this.value.length < 50 ? 
                'La presentación debe tener al menos 50 caracteres' : '');
        });

        // Validación de archivos
        form.elements['cv_url'].addEventListener('change', function() {
            if (this.files[0]?.size > 5 * 1024 * 1024) {
                this.setCustomValidity('El CV no debe exceder 5MB');
            } else {
                this.setCustomValidity('');
            }
        });

        form.elements['foto_url'].addEventListener('change', function() {
            if (this.files[0]?.size > 2 * 1024 * 1024) {
                this.setCustomValidity('La foto no debe exceder 2MB');
            } else {
                this.setCustomValidity('');
            }
        });
    }

    // Inicializar
    form.addEventListener('submit', handleSubmit);
    setupValidations();
});