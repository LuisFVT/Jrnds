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
        // Validar campos de texto
        const textFields = [
            { name: 'nombre', min: 1, message: 'Nombre completo es requerido' },
            { name: 'presentacion', min: 50, message: 'La presentación debe tener al menos 50 caracteres' },
            { name: 'titulo', min: 10, message: 'El título debe tener al menos 10 caracteres' },
            { name: 'tema', min: 10, message: 'El tema debe tener al menos 10 caracteres' }
        ];

        for (const field of textFields) {
            const value = form.elements[field.name].value.trim();
            if (value.length < field.min) {
                showAlert(errorAlert, field.message);
                return false;
            }
        }

        // Validar selects
        const selectFields = [
            { name: 'grado_academico', message: 'Grado académico es requerido' },
            { name: 'carrera', message: 'Área de especialización es requerida' }
        ];

        for (const field of selectFields) {
            if (!form.elements[field.name].value) {
                showAlert(errorAlert, field.message);
                return false;
            }
        }

        // Validar checkboxes
        const checkboxes = form.querySelectorAll('input[name="tipo_participacion[]"]:checked');
        if (checkboxes.length === 0) {
            showAlert(errorAlert, 'Debe seleccionar al menos un tipo de participación');
            return false;
        }

        // Validar archivos
        const cvFile = form.elements['cv_url'].files[0];
        const fotoFile = form.elements['foto_url'].files[0];
        
        if (!cvFile) {
            showAlert(errorAlert, 'El CV es requerido');
            return false;
        }
        
        if (cvFile.size > 5 * 1024 * 1024) {
            showAlert(errorAlert, 'El CV no debe exceder 5MB');
            return false;
        }
        
        if (!fotoFile) {
            showAlert(errorAlert, 'La foto es requerida');
            return false;
        }
        
        if (fotoFile.size > 2 * 1024 * 1024) {
            showAlert(errorAlert, 'La foto no debe exceder 2MB');
            return false;
        }

        return true;
    }

    // Manejar el envío del formulario
    async function handleSubmit(e) {
        e.preventDefault();

        if (!validateForm()) return;

        try {
            loadingIndicator.style.display = 'flex';
            submitButton.disabled = true;

            const formData = new FormData(form);
            
            const response = await fetch(form.action, {
                method: 'POST',
                body: formData
            });

            const result = await response.json();
            
            if (!response.ok) {
                throw new Error(result.message || `Error del servidor (${response.status})`);
            }

            if (result.success) {
                showAlert(successAlert, result.message);
                
                // Deshabilitar formulario después de éxito
                form.querySelectorAll('input, textarea, button, select').forEach(el => {
                    el.disabled = true;
                });
                
                // Redirección
                if (result.redirectUrl) {
                    setTimeout(() => {
                        window.location.href = result.redirectUrl;
                    }, 2000);
                }
            } else {
                throw new Error(result.message || 'Error al procesar la solicitud');
            }
        } catch (error) {
            console.error('Error completo:', error);
            showAlert(errorAlert, error.message || 'Error al enviar el formulario');
        } finally {
            loadingIndicator.style.display = 'none';
            submitButton.disabled = false;
        }
    }

    // Configurar validaciones en tiempo real
    function setupValidations() {
        // Validar campos mientras se escribe
        const validateField = (field, minLength) => {
            const isValid = field.value.trim().length >= minLength;
            const label = field.closest('label');
            if (label) {
                label.classList.toggle('invalid', !isValid);
            }
        };

        // Campos de texto
        const textFields = [
            { element: form.elements['presentacion'], min: 50 },
            { element: form.elements['titulo'], min: 10 },
            { element: form.elements['tema'], min: 10 }
        ];

        textFields.forEach(({element, min}) => {
            if (element) {
                element.addEventListener('input', () => validateField(element, min));
            }
        });

        // Validar checkboxes
        const checkboxContainer = document.querySelector('.checkbox-group');
        if (checkboxContainer) {
            const checkboxes = form.querySelectorAll('input[name="tipo_participacion[]"]');
            checkboxes.forEach(checkbox => {
                checkbox.addEventListener('change', () => {
                    const checked = form.querySelectorAll('input[name="tipo_participacion[]"]:checked');
                    checkboxContainer.classList.toggle('invalid', checked.length === 0);
                });
            });
        }

        // Validar archivos
        const validateFile = (input, maxSize) => {
            const file = input.files[0];
            const isValid = file && file.size <= maxSize;
            const label = input.closest('label');
            if (label) {
                label.classList.toggle('invalid', !isValid);
            }
        };

        const cvInput = form.elements['cv_url'];
        if (cvInput) {
            cvInput.addEventListener('change', () => validateFile(cvInput, 5 * 1024 * 1024));
        }

        const fotoInput = form.elements['foto_url'];
        if (fotoInput) {
            fotoInput.addEventListener('change', () => validateFile(fotoInput, 2 * 1024 * 1024));
        }
    }

    // Inicializar
    form.addEventListener('submit', handleSubmit);
    setupValidations();
});